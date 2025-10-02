FROM alpine:3.14

RUN apk add --no-cache bash

RUN apk update && apk add nginx openssl
RUN mkdir -p /run/nginx && mkdir -p /data/nginx

COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf
COPY ./conf/index.html /data/nginx

RUN chmod 644 /data/nginx/index.html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
