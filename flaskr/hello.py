from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Let's see that curl one more time</p>"
