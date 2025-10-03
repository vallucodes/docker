# docker

https://medium.com/@imyzf/inception-3979046d90a0
https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671
https://github.com/Forstman1/inception-42

https://github.com/vbachele/Inception BEST

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


currently running:
docker ps

ssh -p 2222 vlopatin@localhost
