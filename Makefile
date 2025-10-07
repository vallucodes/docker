DOCKER_COMPOSE_FILE = docker-compose -f srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/${USER}/data/mariadb
	@mkdir -p /home/${USER}/data/wordpress
	$(DOCKER_COMPOSE_FILE) up -d --build

down:
	$(DOCKER_COMPOSE_FILE) down --remove-orphans

wipe:
	@sudo rm -rf /home/vallu/data/mariadb
	@sudo rm -rf /home/vallu/data/wordpress
	$(DOCKER_COMPOSE_FILE) down --volumes --remove-orphans
	docker system prune -a -f --volumes

re: down
	docker system prune -a -f
	$(DOCKER_COMPOSE_FILE) up -d --build
