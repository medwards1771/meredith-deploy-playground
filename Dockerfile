FROM python:3.12.4-alpine3.20

WORKDIR /meredith-deploy-playground

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY flaskr flaskr

WORKDIR /meredith-deploy-playground/flaskr

# Why does --host=0.0.0.0 work, but --host=http://127.0.0.1 doesn't?
# similarly, without the --host specified, i can't get a response on localhost on my machine
# However, when I'm in the container, I can run `wget http://127.0.0.1:5000` and get a response (index.html file)
# Also, observe this terminal output when I run the container NOT as a daemon. Strange:
    # * Running on all addresses (0.0.0.0)
    # * Running on http://127.0.0.1:5000
    # * Running on http://172.17.0.2:5000

# Switch to gunicorn
ENTRYPOINT ["python", "-m", "flask", "--app=hello", "run", "--host=0.0.0.0"]
# CMD python -m flask --app hello run --host=0.0.0.0

# thanks to https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
