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

curl -vk https://vlopatin.42.fr/

VM:

add host vlopatin.42.fr:
sudo nano /etc/hosts
127.0.0.1 vlopatin.42.fr
