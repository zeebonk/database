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

    event write '       Pulling containers'
    foreach application.services as service
        unless config.services[service].image
            config.services[service].image = ...

        docker pull image:config.services[service].image

    event write '       Starting services'
    foreach application.services as service
        # [TODO] attach necessary volumes (e.g., machinebox)
        # [TODO] custom startup commands (e.g., machinebox)
        docker run detach:1
                   entrypoint:'tail -f /dev/null'
                   image:config.services[service].image
                   name:'asyncy--{{service}}-1'

    event write '       Starting Application'
    foreach application.stories as story_name
        http method:'post'
             endpoint:'/run/story'
             data:{'story_name': story_name}

    event write '       Success!'
    event write '-----> Visit http://asyncy.net'
