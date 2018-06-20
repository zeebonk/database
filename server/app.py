import os
import envoy
from storyscript.app import App
import yaml
import json
import requests
import docker as Docker
from raven.contrib.flask import Sentry
from flask import Flask, render_template, send_from_directory
from flask import stream_with_context, request, Response

app = Flask(__name__)
internal_services = ['http-endpoint', 'http', 'log', 'crontab']
sentry = Sentry(app, dsn=os.getenv('SENTRY_DSN'))
sentry.extra_context({'environment': os.getenv('ENVIRONMENT')})
if os.getenv('ENVIRONMENT') == 'alpha':
    sentry.user_context({'id': os.getenv('USER_ID')})


@app.route('/')
def index():
    return render_template(
        'index.html',
        dns=os.getenv('DNS')
    )


@app.route('/assets/<path>')
def assets(path):
    return send_from_directory('assets', path)


@app.route('/healthcheck')
def healthcheck():
    res = envoy.run('../scripts/healthcheck.sh')
    return render_template(
        'healthcheck.html',
        dns=os.getenv('DNS'),
        res=res
    )


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
        'http://api.asyncy.com/graphql',
        data={
            'query': query,
            'variablers': {
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
        'http://api.asyncy.com/graphql',
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


@app.route('/alpha/deploy', methods=['POST'])
def deploy():
    def generate():
        asset_dir = os.environ['ASSET_DIR']
        docker = Docker.from_env()

        # process stories
        yield '-----> Preparing\n'
        yield '       Compiling Stories\n'
        application = App.compile(f'{asset_dir}/app')
        write(application, f'{asset_dir}/config/stories.json')

        application = json.loads(application)

        # produce configuration from asyncy.yml
        config = {}
        if os.path.exists(f'{asset_dir}/app/asyncy.yml'):
            yield '       Processing asyncy.yml\n'
            with open(f'{asset_dir}/app/asyncy.yml', 'r') as file:
                config = yaml.load(file)
            # [TODO] validate /assets/schemas/config.json
            write(config, f'{asset_dir}/config/asyncy.json')

            yield '       Adding environment\n'
            write(config.get('environment', {}),
                  f'{asset_dir}/config/environment.json')

        # loop through containers
        yield '       Provisioning services\n'
        for service in application['services']:
            if service in internal_services:
                yield f'       {service} is internal\n'
                continue
            conf = config.get('services', {}).get(service, {})
            name = f'asyncy--{service}-1'

            # query the Hub for the OMG
            tag = conf.get('tag', 'latest')
            if conf.get('image'):
                pull_url, omg = get_by_slug(conf['image'], tag)
            else:
                pull_url, omg = get_by_alias(service, tag)
            image = f'{pull_url}:{tag}'

            # Shutdown old container
            container = docker.containers.get(name)
            if container:
                yield f'       {service}... Shutting down\n'
                if omg.get('lifecycle', {}).get('shutdown'):
                    container.exec_run(omg['lifecycle']['shutdown']['command'])
                container.stop()
                container.rm()

            # Pull new container
            yield f'       {service}... Pulling new container\n'
            docker.images.pull(image)

            # create volume list
            volumes = ['application-volume:/asyncy']
            if omg.get('volumes'):
                for name, data in omg['volumes'].items():
                    vol_name = f'asyncy--{service}-{name}'
                    if not data.get('persist'):
                        docker.volumes.get(vol_name).remove(True)
                    docker.volumes.create(vol_name)
                    volumes.append(r'{{name}}:{{data["target"]}}')

            # define entrypoint
            entrypoint = omg.get('lifecycle', {}) \
                .get('startup', {}) \
                .get('command', 'tail -f /dev/null')

            # Run the contanier
            yield f'       {service}... Starting\n'
            docker.containers.run(
                image,
                entrypoint=entrypoint,
                volumes=volumes,
                environment=conf.environment,
                name=service_name,
                detach=True
            )

        yield '-----> Restarting Engine\n'
        docker.containers.get('stack-compose_engine_1').restart()

        yield '       Success!\n'
        yield '-----> Visit http://asyncy.net\n'

    return Response(stream_with_context(generate()))


if __name__ == '__main__':
    app.run(host='0.0.0.0')
