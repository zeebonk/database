FROM        jfloff/alpine-python

ADD         . .
RUN         apk update && \
            apk add postgresql-client jq curl curl-dev && \
            pip install -r requirements.txt

ENTRYPOINT  ["./scripts/entrypoint.sh"]
