#!/usr/bin/env sh
set -e

bootstrap() {
    php artisan optimize:clear;
    rr -c .rr.yaml --dotenv=.env serve;
}

bootstrap
