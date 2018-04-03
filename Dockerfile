FROM        jfloff/alpine-python

ADD         . .
RUN         apk update && \
            apk add postgresql-client && \
            pip install -r server/requirements.txt

ENTRYPOINT  ["./scripts/entrypoint.sh"]
