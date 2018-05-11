###
Deploying a new release to Asyncy
  event = {
    data: {
      repo: "myapp",
      commit: "sha",
      branch:  "master"
    },
    write(data:string)
    error(code:int, message:string)
    finish()
  }
###

function New event:object

    production = false
    # [TODO] make sure the repo is registered
    # [TODO] assert git history else require a force push
    # [TODO] get author

    ghse = '/repos/{{repo.slug}}/commits/{{event.data.sha}}/statuses'

    if production
        # [TODO] insert release into database get app from database
        # res = graphql
        # repo =
        # app =
        # release =

        github method:post endpoint:ghse
               data:{
                 'context': 'asyncy/deploy'
               }
        # https://developer.github.com/v3/repos/deployments/#create-a-deployment
        github method:post
               endpoint:'/repos/{{repo.slug}}/deployments'
               data:{
                  'ref': event.data.sha,
                  'task': 'deploy'
                  'required_contexts': ['asyncy/deploy'],
                  'auto_merge': false,
                  'environment': 'production',
                  'description': 'Release v{{release.id}} by @{{author.username}}'
              }

    try
        event.write data:'-----> Preparing'
        git_dir = `~/git/{{event.data.repo}}.git`
        if (file exists dir:git_dir)
            event.write data:'       Extracting git contents'
            git checkout branch:master git_dir:git_dir work_tree:`/app`
            file remove path:git_dir

        else
            event.write data:'       Cloning repository'
            git clone url:repo.slug dest:`/app` depth:1
            file remove path:`/app/.git`

        if (file exists path:`/app/.slugignore`)
            event.write data:'       Removing files from .slugignore'
            file remove globs:(file readlines `/app/.slugignore`)

        event.write data:'       Compiling Stories'
        # process stories into a single json file
        stories = storyscript build dir:`/app`
        file write data:stories path:`/config/stories.json`

        # process asyncy.yml
        if (file exists path:`/app/asyncy.yml`)
            event.write data:'       Processing asyncy.yml'
            config = yaml path:`/app/asyncy.yml`
                          validate:`~/assets/schemas/config.json`
            file write data:config path:`/config/asyncy.json`
        else
            event.write data:'       No asyncy.yml found... Ok'

        if production
            event.write data:'       Adding environment'
            file write data:app.environment
                       path:`/config/env.json`

        event.write data:'       Done.'
        event.write data:''

        event.write data:'-----> Building'

        if production
            event.write data:'       Creating deployment pod'
            # kubectl ...

            event.write data:'       Creating deployment volume'
            # volume = kubectl ...

            event.write data:'       Copying assets into volume'
            file copy from:`/app` to:`{{volume}}:/`

        # [TODO] graphql each service config
        # [TODO] adjust containers based on release tags
        #        for now we pull latest every time
        # [TODO] add the container to our registry
        event.write data:'       Pulling containers'
        foreach stories.services as service
            docker pull name:service

        event.write data:'-----> Deploying'
        if production
            event.write data:'       Starting engine'
            # start engine (docker run -e app_env -v app_volume:/app ...)
        else
            docker restart container:'engine'

        # start containers (standby mode)
        event.write data:'       Starting containers'
        foreach stories.services as service
            # [TODO] attach necessary volumes (e.g., machinebox)
            # [TODO] custom startup commands (e.g., machinebox)
            docker run detach:1
                       entrypoint:'tail -f /dev/null'
                       image:service
                       name:'service-{{service}}'

        event.write data:'       Discovering http routes'
        foreach stories as story
            foreach story.tree.script as ln, line
                if line.parent is null and line.container == 'http'
                    engine exec story:story line:ln

        # [TODO] start crons

        event.write data:'       Done.'
        event.write data:''
        event.write data:'-----> Verifying Deployment'

        if production
            event.write data:'       Release v{{release.id}}'
            github method:post endpoint:ghse
                   data:{
                     'context': 'asyncy/deploy'
                   }

        event.write data:'       Success!'

    except
        if production
            # graphql ...

            github method:post endpoint:ghse
                   data:{
                     'context': 'asyncy/deploy'
                   }

        raise
