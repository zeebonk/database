###
Deploying a new release to Asyncy

  event = {
    data: {
      repo: "myapp",
      commit: "sha",
      branch:  "master",
      user: null           # todo
    },
    write(data:string)
    error(code:int, message:string)
    finish()
  }

###

function NewRelease event:object ->

    # [TODO] make sure the repo is registered
    # [TODO] assert git history else require a force push
    # [TODO] get author

    ghse = '/repos/{{repo.slug}}/commits/{{event.data.sha}}/statuses'

    # [TODO] insert release into database get app from database
    # res = graphql
    # repo =
    # app =
    # release =
    github method:'post' endpoint:ghse
           data:{
             'state': 'pending',
             'target_url': null,
             'description': 'Building application...',
             'context': 'asyncy/deploy'
           }

    try
        event write '-----> Preparing'
        git_dir = file '~/git/{{event.data.repo}}'
        if (git_dir exists)
            git_dir move '/app'
        else
            event write '       Cloning repository'
            git clone url:repo.slug dest:`/app` depth:1
            file remove path:`/app/.git`

        if (file exists path:'/app/.slugignore')
            event write '       Removing files from .slugignore'
            file remove globs:(file readlines '/app/.slugignore')

        event write '       Compiling Stories'
        # process stories into a single json file
        application = storyscript parse target:'/app' json:true
        file write data:application path:'/release/application.json'

        # process asyncy.yml
        if (file exists path:'/app/asyncy.yml')
            event write '       Processing asyncy.yml'
            config = yaml path:'/app/asyncy.yml'
                          validate:'~/assets/schemas/config.json'
            file write data:config path:'/release/config.json'
        else
            event write '       No asyncy.yml found... Ok'

        event write '       Adding environment'
        file write data:app.environment
                   path:'/release/environment.json'

        event write '       Done.\n'
        event write '-----> Building'

        event write '       Creating deployment pod'
        # kubectl ...

        event write '       Creating deployment volume'
        # volume = kubectl ...

        event write '       Copying assets into volume'
        file copy from:'/app' to:'{{volume}}:/'

        event write '       Creating engine'
        # [TODO] start engine (docker run -e app_env -v app_volume:/app ...)

        event write '       Pulling containers'
        foreach application.services as service
            # [TODO] these should pull from Asyncy Registry and not Docker Hub
            docker pull image:config.services[service].image

        event write '       Starting services'
        # [TODO] graphql to get all servie configurations
        foreach application.services as service
            # [TODO] attach necessary volumes (e.g., machinebox)
            # [TODO] custom startup commands (e.g., machinebox)
            # start containers (standby mode)
            docker run detach:1
                       entrypoint:'tail -f /dev/null'
                       image:config.services[service].image
                       name:'service-{{service}}'

        event write '       Starting Application'
        # [TODO] run through all stories in the engine

        event write '       Done.\n'
        event write '-----> Complete'
        event write '       Release v{{release.id}}'
        event write '       Success!'

    except
        # [TODO] graphql ...
        raise
