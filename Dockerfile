FROM registry.cn-hangzhou.aliyuncs.com/docker-image-repo-for-develop/php-base:7.2.27

RUN apk add nginx

COPY s6-service-supervisor/etc/services.d/nginx/run  /etc/services.d/nginx/run
COPY nginx/nginx.conf  /etc/nginx/nginx.conf

COPY s6-service-supervisor/etc/services.d/php-fpm/run  /etc/services.d/php-fpm/run
COPY php-fpm/php-fpm.conf  /use/local/etc/php-fpm.conf

# https://github.com/just-containers/s6-overlay (1.9.1)
COPY s6-overlay-amd64.tar.gz /tmp/s6-overlay-amd64.tar.gz
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

EXPOSE 80

RUN mkdir -p /tmp/storage/framework/views \
    && mkdir -p /tmp/storage/framework/sessions \
    && mkdir -p /tmp/storage/framework/cache \
    && mkdir -p /tmp/storage/framework/testing \
    && mkdir -p /tmp/storage/logs \
    && chmod -R 777 /tmp/storage

ENV STORAGE_PATH=/tmp/storage

ENTRYPOINT ["/init"]
