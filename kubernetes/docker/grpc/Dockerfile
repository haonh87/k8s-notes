FROM haonh87/php:8.1-grpc

ENV ROOT=/var/www/html

ENV USER=rr

WORKDIR ${ROOT}

COPY --chown=${USER}:${USER} . .

RUN mkdir -p \
    storage/framework/{sessions,views,cache,testing} \
    storage/logs \
    bootstrap/cache && chmod -R a+rw storage

COPY --chown=${USER}:${USER} deployment/php.ini ${PHP_INI_DIR}/conf.d/99-rr.ini
COPY --chown=${USER}:${USER} deployment/.rr.prod.yaml ./.rr.yaml
COPY --chown=${USER}:${USER} deployment/.env.prod ./.env
COPY --chown=${USER}:${USER} configs/start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container \
    && composer install \
    --classmap-authoritative \
    --no-interaction \
    --no-ansi \
    && composer clear-cache

ENTRYPOINT ["start-container"]
