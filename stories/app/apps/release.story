###
Building and deploying a new release.

Output https://gist.github.com/stevepeak/efa3cae2ee02fc505925cf22dedfea18
###

# make sure the repo is registed
# make sure the user has permission SSH keys
# assert git history else require a force push
# only accept master branch?

# insert release into database
# get app from database
res = graphql 
app = 

try
    git clone --depth=1 repo.slug `/repo`

    # process stories into a single json file
    list_of_stories = storyscript parse --join `/repo`
    file write list_of_stories `/app/stories.json`

    # process asyncy.yml
    if (file exists `/repo/asyncy.yml`)
        res = yaml `/repo/asyncy.yml` `/assets/schemas/config.json`
        file write res `/app/config.json

    # write environment
    file write app.environment `/app/env.json`
    
    # create release pod
    # create volume
    # move assets
    
    # find all containers in the stories
    # pull containers
    #   if not exist add to our registry from docker
    # start containers (standby mode)

    # start engine (docker run -e app_env -v app_volume:/app ...)

    # find cron/http/stream/mb
    starters = asyncy/find-starting stories
    foreach starters as startnow
        engine start startnow.story startnow.line

except
    # update release as a failure
    # update github release
   

