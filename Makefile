
LISTCONTAINERS := $(shell docker ps -a -q)
LISTIMAGES := $(shell docker images -qa)
LISTVOLUMES := $(shell docker volume ls -q)
LISTNETWORK := $(shell docker network ls -q)

all: up

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d 

down:
	@docker-compose -f ./srcs/docker-compose.yml down

stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

start:
	@docker-compose -f ./srcs/docker-compose.yml start

re:
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

status:
	@docker ps

clean:
	@if [ -n "$(LISTCONTAINERS)" ]; then \
		docker stop $(LISTCONTAINERS); \
		docker rm $(LISTCONTAINERS); \
	fi
	@docker rmi -f  $(LISTIMAGES)
	@docker volume rm  $(LISTVOLUMES)
	@docker network rm  $(LISTNETWORK)

.PHONY: all up down stop start re status clean
