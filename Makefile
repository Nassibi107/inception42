LISTCONTAINERS := $(shell docker ps -a -q)

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
	@docker rmi -f $$(docker images -qa)
	@docker volume rm $$(docker volume ls -q)
	@docker network rm $$(docker network ls -q)

.PHONY: all up down stop start re status clean
