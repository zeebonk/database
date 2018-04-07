FROM        jfloff/alpine-python

ADD         . .
RUN         apk update && \
            apk add postgresql-client jq curl curl-dev && \
            pip install -r server/requirements.txt

ENTRYPOINT  ["./scripts/entrypoint.sh"]
