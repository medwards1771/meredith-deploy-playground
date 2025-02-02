from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>DW Read for President! Please let this be the last time.</p>"
