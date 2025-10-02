FROM alpine:3.14

RUN apk add --no-cache bash

RUN apk update && apk add nginx openssl
RUN mkdir -p /run/nginx && mkdir -p /data/up1

COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
