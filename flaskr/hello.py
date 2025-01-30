from flask import Flask
import redis

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Let's see that curl one more time</p>"

redis_client = redis.Redis(host='localhost', port=6379, decode_responses=True)

@app.route("/redis")
def set_and_get():
    redis_client.set('foo', 'bar')
    response = redis_client.get('foo')
    return response
