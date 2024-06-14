FROM python:3.12.4-alpine3.20

WORKDIR /meredith-deploy-playground
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /meredith-deploy-playground/flaskr

CMD python -m flask --app hello run --host=0.0.0.0
