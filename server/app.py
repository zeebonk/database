import os
from storyscript.app import App
import yaml
import signal
import json
import time
import logging
import requests
import docker as Docker
import tornado.ioloop
import tornado.web
import tornado.httpserver
from tornado.options import define, options
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
        data=json.dumps({
            'query': query,
            'variables': {
                'alias': alias,
                'tag': tag
            }
        })
    )
    res.raise_for_status()

    res = res.json()['data']['serviceByAlias']
    assert res, 'Not found in Asyncy Hub'

    return (
        res['pullUrl'],
        res['serviceTags']['nodes'][0]['configuration']
    )


def get_by_slug(image, tag):
    owner, repo = image.split('/')
    query = open('/assets/queries/release/get_by_slug.gql', 'r').read()
    res = requests.post(
        'https://api.asyncy.com/graphql',
        headers={'Content-Type': 'application/json'},
        data=json.dumps({
            'query': query,
            'variables': {
                'owner': owner,
                'repo': repo,
                'tag': tag
            }
        })
    )
    res.raise_for_status()

    res = res.json()['data']['allOwners'][0]['repos'][0]['services'][0]
    assert res, 'Not found in Asyncy Hub'

    return (
        res['pullUrl'],
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
            self.write('-----> Preparing\n')
            self.fwrite('       Compiling Stories')
            application = App.compile(f'{asset_dir}/app')
            application = json.loads(application)

            write(json.dumps(application),
                  f'{asset_dir}/config/stories.json')

            # produce configuration from asyncy.yml
            config = {}
            environment = {}

            if os.path.exists(f'{asset_dir}/config/environment.json'):
                environment = json.loads(
                    open(f'{asset_dir}/config/environment.json', 'r').read()
                )

            if os.path.exists(f'{asset_dir}/app/asyncy.yml'):
                self.write('       Processing asyncy.yml\n')
                with open(f'{asset_dir}/app/asyncy.yml', 'r') as file:
                    config = yaml.load(file)
                # [TODO] validate /assets/schemas/config.json
                write(config, f'{asset_dir}/config/asyncy.json')

                # [NOTE] Intentionally removed, see https://github.com/asyncy/cli/issues/16
                # self.write('       Adding environment\n')
                # environment = config.get('environment', {})
                # write(environment,
                #       f'{asset_dir}/config/environment.json')

            # loop through containers
            services = {}
            self.fwrite('-----> Provisioning services')
            for service in application['services']:
                if service in internal_services:
                    self.write(f'       {service} is internal\n')
                    continue

                try:
                    conf = config.get('services', {}).get(service, {})
                    name = f'asyncy--{service}-1'

                    # query the Hub for the OMG
                    tag = conf.get('tag', 'latest')
                    if conf.get('image'):
                        pull_url, omg = get_by_slug(conf['image'], tag)
                    else:
                        pull_url, omg = get_by_alias(service, tag)
                    services[service] = {
                        'tag': tag,
                        'configuration': omg
                    }
                    image = f'{pull_url}:{tag}'

                    # Shutdown old container
                    try:
                        container = docker.containers.get(name)
                    except:
                        # container is not yet created
                        pass
                    else:
                        self.fwrite(f'       {service}... Shutting down')
                        if omg.get('lifecycle', {}).get('shutdown'):
                            container.exec_run(omg['lifecycle']['shutdown']['command'])
                        container.stop()
                        container.remove()

                    # Pull new container
                    self.fwrite(f'       {service}... Pulling new container')
                    docker.images.pull(image)

                    # create volume list
                    volumes = ['application-volume:/asyncy']
                    if omg.get('volumes'):
                        for _name, data in omg['volumes'].items():
                            vol_name = f'asyncy--{service}-{_name}'
                            if not data.get('persist'):
                                docker.volumes.get(vol_name).remove(True)
                            docker.volumes.create(vol_name)
                            volumes.append(f'{_name}:{data["target"]}')

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
                        network=self.get_network_stack(),
                        environment=environment.get(service),
                        name=name,
                        detach=True
                    )

                except AssertionError as err:
                    self.fwrite(f'**ERROR**       {service}... {err}')

            # write services file
            write(services, f'{asset_dir}/config/services.json')

            self.fwrite('-----> Restarting Engine')
            docker.containers.list(filters={'name': 'engine_1'})[0].restart()

            self.write('       Success!\n')
            self.write('-----> Visit http://asyncy.net\n')
            self.finish()

        except Exception as error:
            self.fwrite(f'**ERROR**\n{error}')
            self.finish()
            raise

    @staticmethod
    def get_network_stack():
        docker = Docker.from_env()
        networks = docker.networks.list(filters={'name': 'asyncy-backend'})
        if len(networks) > 1:
            raise Exception('There are more than one '
                            'networks for asyncy-backend. Please terminate '
                            'the other running stacks.')
        return networks[0].name


def make_app():
    return tornado.web.Application([
        (r'/alpha/deploy', DeployHandler),
    ])


def shutdown():
    logging.getLogger('torando').info('Stopping http server')
    server.stop()

    logging.getLogger('torando').info('Will shutdown in %s seconds...', 3)
    tornado.ioloop.IOLoop.current().stop()


def sig_handler(sig, frame):
    logging.getLogger('torando').warning('Caught signal: %s', sig)
    tornado.ioloop.IOLoop.current().add_callback(shutdown)


if __name__ == "__main__":
    define("port", default=5000, help='run on the given port', type=int)

    app = make_app()

    global server

    server = tornado.httpserver.HTTPServer(app)
    server.listen(options.port)

    signal.signal(signal.SIGTERM, sig_handler)
    signal.signal(signal.SIGINT, sig_handler)

    app.sentry_client = AsyncSentryClient(dsn=os.getenv('SENTRY_DSN'))
    app.sentry_client.extra_context({'environment': os.getenv('ENVIRONMENT'),
                                     'release': '0.0.1'})
    app.sentry_client.user_context({'id': os.getenv('ASYNCY_USER_ID')})

    tornado.ioloop.IOLoop.instance().start()
