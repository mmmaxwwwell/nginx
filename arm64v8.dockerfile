FROM nginx:latest
RUN apt update && apt install inotify-tools -y && mkdir -p /etc/nginx/staging && mkdir -p /scripts && mkdir -p /etc/letsencrypt/live
COPY ./staging-certs/* /etc/nginx/staging/
COPY ./scripts.d/* /docker-entrypoint.d/
COPY ./scripts/* /scripts/