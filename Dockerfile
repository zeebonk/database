FROM        jfloff/alpine-python

RUN         apk update
RUN         apk add postgresql-client jq curl curl-dev
ADD         . .
RUN         pip install -r requirements.txt

ENTRYPOINT  ["./scripts/entrypoint.sh"]
