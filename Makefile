# -y <file>: specify which file to compose
DOCKER_COMPOSE_FILE = docker-compose -f srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/${USER}/data/mariadb
	@mkdir -p /home/${USER}/data/wordpress
# -d: run containers in the background
	$(DOCKER_COMPOSE_FILE) up -d

down:
# --remove-orphans: remove containers that were created by a previous
#	version of the Compose file but are no longer defined in the current one
	$(DOCKER_COMPOSE_FILE) down --remove-orphans

# remove volumes from host
# --volumes: remove downloaded content like wordpress and maridb
# system prune: remove all unused data (containers, images, networks, etc.)
# -a: extend removing to all images that are not currently running
# -f: skip confirmation prompts
wipe:
	@sudo rm -rf /home/${USER}/data/mariadb
	@sudo rm -rf /home/${USER}/data/wordpress
	$(DOCKER_COMPOSE_FILE) down --volumes --remove-orphans
	docker system prune -a -f --volumes

re: down
	docker system prune -a -f
# -d: run containers in the background
# --build: force build images even if they exist
	$(DOCKER_COMPOSE_FILE) up -d --build
