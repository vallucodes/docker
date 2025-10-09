# docker

https://medium.com/@imyzf/inception-3979046d90a0
https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671
https://github.com/Forstman1/inception-42

https://github.com/vbachele/Inception BEST

Alpine:
https://github.com/barimehdi77/inception/tree/main/srcs/requirements
https://github.com/mcombeau/inception/tree/main/srcs/requirements

vallu
vboxhome

/media/sf_shared

cd inception/srcs/requirements/nginx

build:
docker build -t nginx .

run:
docker run -d -p 80:80 --name web nginx && docker exec -it web /bin/sh
stop:
docker stop web && docker rm web

build and run:
docker-compose up --build -d
stop:
docker-compose down --volumes --remove-orphans

currently running:
docker ps -a

debug container if it crashed:
docker ps -a
docker cp <container id>:/var/lib/mysql/<container id>.err .

check for errors:
docker logs <container name>

ssh -p 2222 vlopatin@localhost

VM:
add host vlopatin.42.fr:
sudo nano /etc/hosts
127.0.0.1 vlopatin.42.fr

curl -k -I -v --tlsv1 --tls-max 1.2 https://localhost


testing:

docker stop $(docker ps -qa);
docker rm $(docker ps -qa);
docker rmi -f $(docker images -qa);
docker volume rm $(docker volume ls -q);
docker network rm $(docker images -qa);
docker network rm $(docker network ls -q) 2>/dev/null;

curl -vk https://vlopatin.42.fr

# 2>&1 redirects stderr (2) to stdout (1)
curl -vk https://vlopatin.42.fr 2>&1 | grep TLSv

curl -I http://vlopatin.42.fr
curl -I https://vlopatin.42.fr

openssl: the OpenSSL command=line tool for managing SSL/TLS operations
s_client: a subcommand that acts like a client connecting to a TLS/SSL server. It’s used for testing and debugging SSL/TLS connections.
-connect vlopatin.42.fr:443: specifies the host and port of the server you want to connect to.
-tls1_1: tells OpenSSL to attempt only TLS 1.1 during the handshake.
openssl s_client -connect vlopatin.42.fr:443 -tls1_1
openssl s_client -connect vlopatin.42.fr:443 -tls1_2
openssl s_client -connect vlopatin.42.fr:443 -tls1_3


# -v: verbose output with handshake
# -k: bypass self-signed sertificate
# -I: see ony headers
curl -v http://vlopatin.42.fr:80
curl -v https://vlopatin.42.fr

curl -k https://vlopatin.42.fr:443
curl -k http://vlopatin.42.fr:80

https://vlopatin.42.fr/wp-admin

docker exec -it mariadb bash
mariadb -u root -p
mariadb -h mariadb -u wp_user -p

SHOW DATABASES;
USE inception
SHOW TABLES;
SELECT * FROM wp_users;
USE mysql;
EXIT;

