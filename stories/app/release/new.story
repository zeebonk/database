###
Deploying a new release to Asyncy
  repository = {
    "repo": "myapp",
    "commit": "sha",
    "branch":  "master"
  }
  output = (response write)
###

with repository:object, output:function

    production = false
    # [TODO] make sure the repo is registered
    # [TODO] assert git history else require a force push

    if production
        # [TODO] insert release into database get app from database
        # res = graphql
        # app =
        # release =

        github method:post
               endpoint:'/repos/{{repo.slug}}/commits/{{data.sha}}/statuses'
               data:{ }
        # https://developer.github.com/v3/repos/deployments/#create-a-deployment
        github method:post
               endpoint:'/repos/{{repo.slug}}/deployments'
               data:{
                  'ref': data.sha,
                  'task': 'deploy'
                  'required_contexts': ['asyncy/deploy'],
                  'auto_merge': false,
                  'environment': 'production',
                  'description': 'Release v{{release.id}} by @{{data.author.username}}'
              }

    try
        output message:'-----> Preparing'
        git_dir = `~/tmp/git/{{data.repo}}.git`
        if (file exists dir:git_dir)
            output message:'       Extracting git contents'
            git checkout branch:master git_dir:git_dir work_tree:`/app`
            file remove path:git_dir

        else
            output message:'       Cloning repository'
            git clone url:repo.slug dest:`/app` depth:1
            file remove path:`/app/.git`

        if (file exists path:`/app/.slugignore`)
            output message:'       Removing files from .slugignore'
            file remove globs:(file readlines `/app/.slugignore`)

        output message:'       Compiling Stories'
        # process stories into a single json file
        stories = storyscript build dir:`/app`
        file write data:stories path:`/config/stories.json`

        # process asyncy.yml
        if (file exists path:`/app/asyncy.yml`)
            output message:'       Processing asyncy.yml'
            config = yaml `/app/asyncy.yml` `~/assets/schemas/config.json`
            file write data:config path:`/config/asyncy.json`
        else
            output message:'       No asyncy.yml found... Ok'

        if production
            output message:'       Adding environment'
            file write data:app.environment path:`/config/env.json`

        output message:'       Done.'
        output message:''

        output message:'-----> Building'

        if production
            output message:'       Creating deployment pod'
            # kubectl ...

            output message:'       Creating deployment volume'
            # volume = kubectl ...

            output message:'       Copying assets into volume'
            file copy from:`/app` to:`{{volume}}:/`

        # [TODO] graphql each service config
        # [TODO] adjust containers based on release tags
        #        for now we pull latest every time
        # [TODO] add the container to our registry
        output message:'       Pulling containers'
        for service in stories.services
            docker pull name:service


        output message:'-----> Deploying'
        if production
            output message:'       Starting engine'
            # start engine (docker run -e app_env -v app_volume:/app ...)
        else
            docker restart container:'engine'

        # start containers (standby mode)
        output message:'       Starting containers'
        for service in stories.services
            # [TODO] attach necessary volumes (e.g., machinebox)
            # [TODO] custom startup commands (e.g., machinebox)
            docker run detach:1
                       entrypoint:'tail -f /dev/null'
                       image:service
                       name:'service-{{service}}'

        output message:'       Discovering http routes'
        for story in stories
            for ln, line in story.tree.script
                if line.parent is null and line.container == 'http'
                    engine exec story:story line:ln

        # [TODO] start crons

        output message:'       Done.'
        output message:''
        output message:'-----> Verifying Deployment'
        if production
            output message:'       Release v{{release.id}}'
        output message:'       Success!'


    except
        if production
            # graphql ...

            github method:post
                   endpoint:'/repos/{{repo.slug}}/commits/{{data.sha}}/statuses'
                   data:{ }

        raise
