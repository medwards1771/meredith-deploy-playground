from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>DW Read 4 President</p>"