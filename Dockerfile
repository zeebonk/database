FROM        jfloff/alpine-python

ADD         . .
RUN         apk update && \
            apk add postgresql-client jq curl curl-dev && \
            pip install -r requirements.txt && \
            storyscript parse -j /stories/app/release/alpha.story > /deploy.json

ENTRYPOINT  ["./scripts/entrypoint.sh"]
