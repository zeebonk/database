###
Server to accept github webhooks for Story repo changes
###
import `../apps` as Apps
import `events` as Events

# https://developer.github.com/webhooks
github webhooks as request, response

    # assert repository is registered with Asyncy
    repo = Apps.get slug:request.body.repository.full_name
    if repo
        event = request.headers['X-GitHub-Event']
        Events[event] repo:repo
