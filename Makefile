DOCKER_COMPOSE_FILE = docker-compose -f srcs/docker-compose.yml

all: up

up:
	$(DOCKER_COMPOSE_FILE) up -d --build

down:
	$(DOCKER_COMPOSE_FILE) down --remove-orphans

wipe:
	$(DOCKER_COMPOSE_FILE) down --volumes --remove-orphans
	docker system prune -a -f --volumes

re: down
	docker system prune -a -f
	$(DOCKER_COMPOSE_FILE) up -d --build
