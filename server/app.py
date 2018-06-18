import os
import envoy
import yaml
import json
import requests
import docker as Docker
from flask import Flask, render_template, send_from_directory
from flask import stream_with_context, request, Response

app = Flask(__name__)


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


def getByAlias(alias, tag):
    query = f'''
    {
      query {
        serviceByAlias(alias: "{{alias}}"){
          pull_url
          serviceTags(condition: {tag: "{{tag}}"} first:1){
            nodes{
              configuration
            }
          }
        }
      }
    }
    '''
    res = requests.post(
        'http://api.asyncy.com/graphql',
        data={'query': query}
    ).json()['data']['query']['serviceByAlias']

    return (
        f'{{res["pull_url"]}}:{{tag}}',
        res['serviceTags']['nodes'][0]['configuration']
    )


def getBySlug(iamge, tag):
    owner, repo = image.split('/')
    query = f'''
    {
      query {
        allOwners(condition: {name: "{{owner}}"}, first: 1){
          nodes{
            repos(condition: {name: "{{repo}}"}, first:1){
              nodes{
                services(first:1){
                  nodes{
                    pullUrl
                    serviceTags(condition: {tag: "{{tag}}"} first:1){
                      nodes{
                        configuration
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    '''
    res = requests.post(
        'http://api.asyncy.com/graphql',
        data={'query': query}
    ).json()['data']['query']['allOwners'][0]['repos'][0]['services'][0]

    return (
        f'{{res["pull_url"]}}:{{tag}}',
        res['serviceTags']['nodes'][0]['configuration']
    )


@app.route('/alpha/deploy', method='POST')
def deploy():
    def generate():
        docker = Docker.from_env()

        # process stories
        yield '-----> Preparing'
        yield '       Compiling Stories'
        application = storyscript.parse('/asyncy/app')
        write(application, '/asyncy/config/stories.json')

        # produce configuration from asyncy.yml
        config = {}
        if os.path.exists('/asyncy/app/asyncy.yml'):
            yield '       Processing asyncy.yml'
            with open('/asyncy/app/asyncy.yml', 'r') as file:
                config = yaml.load(file)
            # [TODO] validate /assets/schemas/config.json
            write(config, '/asyncy/config/asyncy.json')

            yield '       Adding environment'
            write(config.get('environment', {}),
                  '/asyncy/config/environment.json')

        # loop through containers
        yield '       Provisioning services'
        for service in application['services']:
            conf = config['services'][service]
            name = f'asyncy--{{service}}-1'

            image = conf.get('image')
            tag = conf.get('tag', 'latest')

            if image:
                image, omg = getBySlug(image, tag)
            else:
                image, omg = getByAlias(service, tag)

            # Shutdown old container
            container = docker.containers.get(name)
            if container:
                yield f'       {{service}}... Shutting down'
                if omg.get('lifecycle', {}).get('shutdown'):
                    container.exec_run(omg['lifecycle']['shutdown']['command'])
                container.stop()
                container.rm()

            # Pull new container
            yield f'       {{service}}... Pulling new container'
            docker.images.pull(image)

            # create volume list
            volumes = ['application-volume:/asyncy']
            if omg.get('volumes'):
                for name, data in omg['volumes'].items():
                    vol_name = f'asyncy--{{service}}-{{name}}'
                    if not data.get('persist'):
                        docker.volumes.get(vol_name).remove(True)
                    docker.volumes.create(vol_name)
                    volumes.append(r'{{name}}:{{data["target"]}}')

            # define entrypoint
            entrypoint = omg.get('lifecycle', {})
                             .get('startup', {})
                             .get('command', 'tail -f /dev/null')

            # Run the contanier
            yield f'       {{service}}... Starting'
            docker.containers.run(
                image,
                entrypoint=entrypoint,
                volumes=volumes,
                environment=conf.environment,
                name=service_name,
                detach=True
            )

        yield '       Success!'
        yield '-----> Visit http://asyncy.net'

    return Response(stream_with_context(generate()))


if __name__ == '__main__':
    app.run(host='0.0.0.0')
