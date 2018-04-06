import os
import envoy
from flask import Flask, render_template, send_from_directory

app = Flask(__name__)


@app.route('/')
def index():
    return render_template(
        'index.html',
        dns=os.getenv('DNS')
    )


@app.route('/assets/<path>')
def assets(path):
    return send_from_directory('assets', path)

@app.route('/grafana/<path:path>')
def send_grafana(path):
    return send_from_directory('../grafana', path)

@app.route('/healthcheck')
def healthcheck():
    res = envoy.run('../scripts/healthcheck.sh')
    return render_template(
        'healthcheck.html',
        dns=os.getenv('DNS'),
        res=res
    )


if __name__ == '__main__':
    app.run(host='0.0.0.0')
