FROM alpine:3.14

RUN apk add --no-cache bash

# Download nginx and ssl
RUN apk update && apk add nginx openssl

# Create directory structure
RUN mkdir -p /run/nginx && mkdir -p /data/nginx
RUN mkdir -p /etc/nginx/ssl

# Generate a certificate
RUN openssl req -x509 -nodes -days 365 -newkey ed25519 \
	-keyout	/etc/nginx/ssl/nginx.key \
	-out	/etc/nginx/ssl/nginx.crt \
	-subj	"/CN=localhost"

# Copy webpage and server config to container
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf
COPY ./conf/index.html /data/nginx

# Set permissions for website
RUN chmod 644 /data/nginx/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
