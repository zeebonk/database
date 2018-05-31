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

    event write '-----> Preparing'
    event write '       Compiling Stories'
    application = storyscript parse target:'/app' json:true
    file write data:application path:'/config/application.json'


    if (file exists path:'/app/asyncy.yml')
        event write '       Processing asyncy.yml'
        config = yaml path:'/app/asyncy.yml'
                      validate:'~/assets/schemas/config.json'
        file write data:config path:'/config/asyncy.json'

    event write '       Adding environment'
    file write data:config.environment path:'/config/environment.json'

    event write '       Provisioning services'
    foreach application.services as service
        conf = config.services[service]
        name = 'asyncy--{{service}}-1'

        # shutdown
        event write '       {{service}}... Shutting down '
        if conf.lifecycle.shutdown
            docker exec :name command:conf.lifecycle.shutdown.command

        # stop and remove
        docker stop :name
        docker rm :name

        # pull
        event write '       {{service}}... Pulling new container'
        docker pull image:(conf.image or 'latest')

        # attach volumes
        volumes = ['application-volume:/asyncy']
        if conf.volumes
            # loop through all the custom volumes
            foreach conf.volumes as name, data
                vol_name = 'asyncy--{{service}}-{{name}}'
                # drop old volume
                unless data.persist
                    docker volume command:'rm' name:vol_name force:true

                # create volume
                docker volume command:'create' name:vol_name
                # add to volume list
                volumes append '{{name}}:{{data.target}}'

        # setup entrypoint
        entrypoint = (conf.lifecycle.startup.command or 'tail -f /dev/null')

        event write '       {{service}}... Starting'
        docker run :entrypoint
                   :volumes
                   environment:conf.environment
                   image:(conf.image or 'latest')
                   name:service_name
                   detach:true

    event write '       Starting Application'
    foreach application.stories as story_name
        http method:'post'
             endpoint:'http://{{engine}}/run/story'
             data:{'story_name': story_name}

    event write '       Success!'
    event write '-----> Visit http://asyncy.net'
