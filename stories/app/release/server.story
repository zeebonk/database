import `./new.story` as NewRelease

# build the release via `git push asyncy master`
asyncy/platform-service-git accept as request, response
    NewRelease repository:request.body
               output:(response write)
