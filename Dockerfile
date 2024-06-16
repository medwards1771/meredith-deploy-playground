FROM python:3.12.4-alpine3.20

WORKDIR /meredith-deploy-playground

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY flaskr flaskr
WORKDIR /meredith-deploy-playground/flaskr
ENTRYPOINT ["gunicorn", "--workers=4", "--timeout=120", "--bind=0.0.0.0", "hello:app"]
