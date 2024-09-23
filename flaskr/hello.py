from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Are you ready to ruuuuuumble?</p>"