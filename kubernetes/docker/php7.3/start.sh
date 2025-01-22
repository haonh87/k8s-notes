#!/bin/sh

# Start supervisord and services
supervisord -n -c /etc/supervisor/conf.d/supervisord.conf