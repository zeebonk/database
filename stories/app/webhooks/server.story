###
Server to accept github webhooks for Story repo changes
###

# https://developer.github.com/webhooks
github accept-webhooks as webhook

    # assert repository is registered with Asyncy
    repo = asyncy/repository webhook.data.repository.full_name
    unless repo
        exit

    event = webhook.headers['X-GitHub-Event']
    next `events/{event}`
