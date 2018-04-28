###
Run tests against service
###

slug = webhook.data.repository.full_name
sha = webhook.data.head_commit.id
status_endpoint = '/repos/{{slug}}/statuses/{{sha}}'
target_url = '{{env.url}}/gh/{{slug}}/builds/{{__TBD__}}'

github post status_endpoint {
    'state': 'pending'
    'description': 'Running test suite...'
    'target_url': target_url
    'context': 'ci/asyncy'
}

res = {}

try
    # clone the repo
    github clone webhook.data.ssh_url `/clone`

    ###
    Storyscripts
    ###
    res.stories = storyscript parse `/clone`

    ###
    Yaml
    ###
    res.yaml = validate (yaml parse `/clone/asyncy.yml`) `yaml.json`

    ###
    Environment
      Assert environment is properly setup
    ###
    res.environment = asyncy/ci-env {
        'stories': res.stories
        'environment': (json merge repo.property.env res.yaml.env)
    }

    ###
    Container
      Assert all containers exist in the Hub
    ###
    res.container = asyncy/ci-containers {
        'stories': res.stories
        'environment': res.environment
        'yaml': res.yaml
        'clone': `/clone`
    }

    ###
    Registry
    ###
    res.registry = next `registry.story`

    state = 'success'
    description = 'Build success! :tada:'

catch as error
    # [TODO] store output
    state = 'failure'
    description = 'Build failed :frown:'

github post status_endpoint {
    'state': state
    'description': description
    'target_url': target_url
    'context': 'ci/asyncy'
}
