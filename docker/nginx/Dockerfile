FROM nginx:1.27-alpine-slim

COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/flaskr-server-block /etc/nginx/sites-available/flaskr/
