
# usage
# docker build --no-cache -f Dockerfile -t haonh87/node:22.11-nginx .

# STAGE 1: BUILD VUEJS WITH NODE
# NODE 22.X (LTS)
FROM node:22.11-alpine

# # #
# INSTALL SYSTEM DEPENDENCES
# # #
RUN apk update && apk upgrade && \
    apk add --no-cache wget curl ca-certificates gcc \
        tzdata \
        s6 ssmtp \
        bash \
        linux-headers \
        nginx &&\
        rm /var/cache/apk/* && \
        rm -Rf /etc/nginx/nginx.conf && \
        rm -Rf /etc/nginx/conf.d/default.conf


# SET WORKING DIRECTORY FOR APPLICATION
ENV WORKDIR=/app


# CONFIGURE APPLICATION FOR DEVELOPMENT ENV
# CMD ["npm", "run", "dev"]



# COPY NGINX CONFIGURATION
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/conf.d /etc/nginx/conf.d/

# EXPOSE PORT 3000 FOR VUEJS SERVER AND 80 FOR NGINX
EXPOSE 8080 80

# EXPOSE PORT 80 FOR NGINX
#CMD ["nginx", "-g", "daemon off;"]