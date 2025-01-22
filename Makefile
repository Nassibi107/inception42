
LISTCONTAINERS := $(shell docker ps -a -q)
LISTIMAGES := $(shell docker images -qa)


all: up

up:
	@mkdir  -p ~/data/mariadb
	@mkdir  -p ~/data/wordpress
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
	@if [ -n "$(LISTIMAGES)" ]; then \
		docker rmi -f  $(LISTIMAGES); \
		docker volume rm  mariadb wordpress ;\
		docker network rm  srcs_inception;\
	fi

.PHONY: all up down stop start re status clean
