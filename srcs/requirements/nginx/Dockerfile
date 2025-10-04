FROM alpine:3.14

RUN apk update
RUN apk add --no-cache bash curl nginx openssl

# Create directory structure
RUN mkdir -p /run/nginx && mkdir -p /var/www/wordpress
RUN mkdir -p /etc/nginx/ssl

# Generate a certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout	/etc/nginx/ssl/nginx.key \
	-out	/etc/nginx/ssl/nginx.crt \
	-subj	"/CN=localhost"

# Copy webpage and server config to container
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf
# COPY ./conf/index.html /data/nginx

# Set permissions for website
# RUN chmod -R 755 /data/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
