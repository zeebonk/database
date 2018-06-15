function NewRelease event:object ->

    event write content:'-----> Preparing'
    event write content:'       Compiling Stories'
    application = storyscript parse target:'/app' json:true
    file write data:application path:'/config/stories.json'

    yaml_exist = file exists path:'/app/asyncy.yml'
    if yaml_exist
        event write content:'       Processing asyncy.yml'
        config = yaml path:'/app/asyncy.yml' validate:'/config/asyncy-schema.json'
        file write data:config path:'/config/asyncy.json'

    event write content:'       Adding environment'
    file write data:config.environment path:'/config/environment.json'

    event write content:'       Provisioning services'
    foreach application.services as service
        conf = config.services[service]
        name = 'asyncy--{{service}}-1'
        if conf.image
          image = conf.image
        else
          image = 'latest'

        event write content:'       {{service}}... Shutting down'
        if conf.lifecycle.shutdown
            docker exec name:name command:conf.lifecycle.shutdown.command

        docker stop name:name
        docker rm name:name

        event write content:'       {{service}}... Pulling new container'
        docker pull image:image

        volumes = ['application-volume:/asyncy']
        if conf.volumes
            foreach conf.volumes as name, data
                vol_name = 'asyncy--{{service}}-{{name}}'
                if data.persist
                    pass
                else
                    docker volume command:'rm' name:vol_name force:true

                docker volume command:'create' name:vol_name
                volumes append '{{name}}:{{data.target}}'

        if conf.lifecycle.startup.command
          entrypoint = conf.lifecycle.startup.command
        else
          entrypoint = 'tail -f /dev/null'

        event write content:'       {{service}}... Starting'
        docker run entrypoint:entrypoint volumes:volumes environment:conf.environment image:image name:service_name detach:true

    event write content:'       Success!'
    event write content:'-----> Visit http://asyncy.net'
