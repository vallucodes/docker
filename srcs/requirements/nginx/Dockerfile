FROM alpine:3.14

RUN apk update

# Download bash, curl, nginx, ssl
RUN apk add --no-cache bash curl nginx openssl

# Create directory structure
RUN mkdir -p /etc/nginx/ssl /var/www/wordpress

# Generate a certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout	/etc/nginx/ssl/nginx.key \
	-out	/etc/nginx/ssl/nginx.crt \
	-subj	"/CN=localhost"

# Copy webpage and server config to container
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
