import os
from storyscript.app import App
import yaml
import json
import requests
import docker as Docker
import tornado.ioloop
import tornado.web
from tornado import gen
from raven.contrib.tornado import AsyncSentryClient
from raven.contrib.tornado import SentryMixin

internal_services = ['http-endpoint', 'http', 'log', 'crontab']


def write(content, location):
    dir = os.path.dirname(location)
    if not os.path.exists(dir):
        os.makedirs(dir)

    if isinstance(content, (list, dict)):
        content = json.dumps(content)

    with open(location, 'w+') as file:
        file.write(content)


def get_by_alias(alias, tag):
    query = open('/assets/queries/release/get_by_alias.gql', 'r').read()
    res = requests.post(
        'https://api.asyncy.com/graphql',
        headers={'Content-Type': 'application/json'},
        data={
            'query': query,
            'variables': {
                'alias': alias,
                'tag': tag
            }
        }
    )
    res.raise_for_status()

    res = res.json()['data']['serviceByAlias']

    return (
        res['pull_url'],
        res['serviceTags']['nodes'][0]['configuration']
    )


def get_by_slug(image, tag):
    owner, repo = image.split('/')
    query = open('/assets/queries/release/get_by_slug.gql', 'r').read()
    res = requests.post(
        'https://api.asyncy.com/graphql',
        headers={'Content-Type': 'application/json'},
        data={
            'query': query,
            'variables': {
                'owner': owner,
                'repo': repo,
                'tag': tag
            }
        }
    )
    res.raise_for_status()

    res = res.json()['data']['allOwners'][0]['repos'][0]['services'][0]

    return (
        res['pull_url'],
        res['serviceTags']['nodes'][0]['configuration']
    )


class DeployHandler(SentryMixin, tornado.web.RequestHandler):
    def fwrite(self, data):
        self.write(data)
        self.flush()

    def post(self):
        try:
            asset_dir = os.environ['ASSET_DIR']
            docker = Docker.from_env()

            # process stories
            self.fwrite('-----> Preparing')
            self.fwrite('       Compiling Stories')
            application = App.compile(f'{asset_dir}/app')
            write(application, f'{asset_dir}/config/stories.json')

            application = json.loads(application)

            # produce configuration from asyncy.yml
            config = {}
            if os.path.exists(f'{asset_dir}/app/asyncy.yml'):
                self.fwrite('       Processing asyncy.yml')
                with open(f'{asset_dir}/app/asyncy.yml', 'r') as file:
                    config = yaml.load(file)
                # [TODO] validate /assets/schemas/config.json
                write(config, f'{asset_dir}/config/asyncy.json')

                self.fwrite('       Adding environment')
                write(config.get('environment', {}),
                      f'{asset_dir}/config/environment.json')

            # loop through containers
            services = {}
            self.fwrite('       Provisioning services')
            for service in application['services']:
                if service in internal_services:
                    self.fwrite(f'       {service} is internal')
                    continue
                conf = config.get('services', {}).get(service, {})
                name = f'asyncy--{service}-1'

                # query the Hub for the OMG
                tag = conf.get('tag', 'latest')
                if conf.get('image'):
                    pull_url, omg = get_by_slug(conf['image'], tag)
                else:
                    pull_url, omg = get_by_alias(service, tag)
                services[service] = omg
                image = f'{pull_url}:{tag}'

                # Shutdown old container
                container = docker.containers.get(name)
                if container:
                    self.fwrite(f'       {service}... Shutting down')
                    if omg.get('lifecycle', {}).get('shutdown'):
                        container.exec_run(omg['lifecycle']['shutdown']['command'])
                    container.stop()
                    container.rm()

                # Pull new container
                self.fwrite(f'       {service}... Pulling new container')
                docker.images.pull(image)

                # create volume list
                volumes = ['application-volume:/asyncy']
                if omg.get('volumes'):
                    for name, data in omg['volumes'].items():
                        vol_name = f'asyncy--{service}-{name}'
                        if not data.get('persist'):
                            docker.volumes.get(vol_name).remove(True)
                        docker.volumes.create(vol_name)
                        volumes.append(f'{name}:{data["target"]}')

                # define entrypoint
                entrypoint = omg.get('lifecycle', {}) \
                    .get('startup', {}) \
                    .get('command', 'tail -f /dev/null')

                # Run the contanier
                self.fwrite(f'       {service}... Starting')
                docker.containers.run(
                    image,
                    entrypoint=entrypoint,
                    volumes=volumes,
                    environment=conf.environment,
                    name=service_name,
                    detach=True
                )

            # write services file
            write(services, f'{asset_dir}/config/services.json')

            self.fwrite('-----> Restarting Engine')
            docker.containers.list(filters={'name': 'engine_1'})[0].restart()

            self.write('       Success!\n')
            self.write('-----> Visit http://asyncy.net\n')

        except Exception as error:
            self.captureException()
            self.write('**ERROR**\n')
            self.write(str(error))

        finally:
            self.finish()


def make_app():
    return tornado.web.Application([
        (r'/alpha/deploy', DeployHandler),
    ])


if __name__ == "__main__":
    app = make_app()
    app.listen(5000)

    app.sentry_client = AsyncSentryClient(dsn=os.getenv('SENTRY_DSN'))
    app.sentry_client.extra_context({'environment': os.getenv('ENVIRONMENT')})
    app.sentry_client.user_context({'id': os.getenv('ASYNCY_USER_ID')})

    tornado.ioloop.IOLoop.current().start()
