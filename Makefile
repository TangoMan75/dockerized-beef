#/**
# * TangoMan BeEF
# *
# * @version  0.1.0
# * @author   "Matthias Morin" <mat@tangoman.io>
# * @licence  MIT
# * @link     https://github.com/TangoMan75/makefile-generator
# * @link     https://www.linkedin.com/in/morinmatthias
# */

.PHONY: help up build open start status volumes logs stop kill remove top stop-all kill-all clean remove-all

# Colors
TITLE     = \033[1;42m
CAPTION   = \033[1;44m
BOLD      = \033[1;34m
LABEL     = \033[1;32m
DANGER    = \033[31m
SUCCESS   = \033[32m
WARNING   = \033[33m
SECONDARY = \033[34m
INFO      = \033[35m
PRIMARY   = \033[36m
DEFAULT   = \033[0m
NL        = \033[0m\n

image?=Alpine-BeEF.dockerfile
container?=beef
# app path (will append to container's ip e.g: `http://172.17.0.2/index.php`)
app_route?=/ui/panel
# valid parameter = bridge, host, macvlan or none
network?=host

## Print this help
help:
	@printf "${TITLE} TangoMan BeEF ${NL}\n"

	@printf "${CAPTION} Infos:${NL}"
	@printf "${PRIMARY} %-10s${INFO} %s${NL}" "username" "root"
	@printf "${PRIMARY} %-10s${INFO} %s${NL}\n" "password" "toor"

	@printf "${CAPTION} Description:${NL}"
	@printf "${WARNING} TangoMan BeEF${NL}\n"

	@printf "${CAPTION} Usage:${NL}"
	@printf "${WARNING} make [command] `awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"%s=[%s]\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq|tr '\n' ' '`${NL}\n"

	@printf "${CAPTION} Config:${NL}"
	$(eval CONFIG:=$(shell awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"$${PRIMARY}%-10s$${DEFAULT} $${INFO}$${%s}$${NL}\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq))
	@printf " ${CONFIG}\n"

	@printf "${CAPTION} Commands:${NL}"
	@awk '/^### /{printf"\n${BOLD}%s${NL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if(match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf " ${LABEL}%-10s${DEFAULT} ${PRIMARY}%s${NL}",substr($$1,0,index($$1,":")),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

##################################################
### BeEF
##################################################

## Start and open in default browser (build start status open)
up: build start status open

## Build container
build:
ifeq ($(shell test -f ./${image} && echo true),true)
	@printf "${INFO}docker build . -f ./${image} -t ${container}${NL}"
	@docker build . -f ./${image} -t ${container}
else
	@printf "${WARNING}Dockerfile not found, skipping${NL}"
endif

## Open in default browser
open:
ifeq ($(shell docker inspect -f '{{ .NetworkSettings.IPAddress }}' ${container} 2>/dev/null),)
	@printf "${INFO}xdg-open http://localhost${app_route}${NL}"
	@xdg-open http://localhost${app_route}
else
	@printf "${INFO}xdg-open http://`docker inspect -f '{{ .NetworkSettings.IPAddress }}' ${container}`${app_route}${NL}"
	@xdg-open http://`docker inspect -f '{{ .NetworkSettings.IPAddress }}' ${container}`${app_route}
endif

##################################################
### Docker Container
##################################################
 
## Start container
start:
	@printf "${INFO}docker run --detach --name ${container} --network ${network} --rm -P ${container}${NL}"
	@docker run --detach --name ${container} --network ${network} --rm -P ${container}

## Print image status
status:
	@printf "${LABEL}image:      ${INFO}%s${NL}"        "`docker inspect --format '{{ .Config.Image }}' ${container} 2>/dev/null`"
	@printf "${LABEL}hostname:   ${INFO}%s${NL}"        "`docker inspect --format '{{ .Config.Hostname }}' ${container} 2>/dev/null`"
ifneq ($(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container}),)
	@printf "${LABEL}ip address: ${INFO}%s${NL}"        "`docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container} 2>/dev/null`"
	@printf "${LABEL}open ports: ${INFO}%s${NL}"        "`docker port ${container} 2>/dev/null`"
	@printf "${LABEL}local url:  ${INFO}http://%s${NL}" "`docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container} 2>/dev/null`"
else
	@if [ ${network} != 'host' ]; then \
		printf "${LABEL}ip address: ${DANGER}error${NL}"; \
		printf "${LABEL}open ports: ${DANGER}error${NL}"; \
	else \
		printf "${LABEL}ip address: ${INFO}127.0.0.1${NL}"; \
		printf "${LABEL}local url:  ${INFO}http://localhost${NL}"; \
	fi
endif

## Print container volumes
volumes:
ifeq ($(shell test -x `which python 2>/dev/null` && echo true),true)
	@printf "${INFO}docker inspect --format='{{ json .Mounts }}' ${container} ${NL}"
	@docker inspect --format='{{ json .Mounts }}' ${container} 2>/dev/null | python -m json.tool
else
	@printf "${INFO}docker inspect --format='{{ json .Mounts }}' ${container} ${NL}"
	@docker inspect --format='{{ json .Mounts }}' ${container} 2>/dev/null
endif

## Print container logs
logs:
	@printf "${INFO}docker logs ${container} --tail 5${NL}"
	@docker logs ${container} --tail 5

## Stop container
stop:
	@printf "${INFO}docker stop ${container}${NL}"
	@docker stop ${container}

## Kill container
kill:
	@printf "${INFO}docker kill ${container}${NL}"
	@docker kill ${container}
	@printf "${INFO}docker rm ${container} 2>/dev/null${NL}"
	@docker rm ${container} 2>/dev/null

## Stop and remove image
remove:
	-@make -s kill
	@printf "${INFO}docker image rm ${container}${NL}"
	@docker image rm ${container}

##################################################
### Docker Manager
##################################################

## List images, volumes and network information
top:
	@printf "${INFO}docker ps --all${NL}"
	@docker ps --all
	@printf "${INFO}docker images --all${NL}"
	@docker images --all
	@printf "${INFO}docker volume ls${NL}"
	@docker volume ls
	@printf "${INFO}docker network ls${NL}"
	@docker network ls
	@printf "${INFO}docker inspect --format '{{ .Name }}: {{ .NetworkSettings.IPAddress }}' `docker ps --quiet | tr '\n' ' '` 2>/dev/null${NL}"
	@docker inspect --format '{{ .Name }}: {{ .NetworkSettings.IPAddress }}' `docker ps --quiet | tr '\n' ' '` 2>/dev/null

## Stop all running containers
stop-all:
	@printf "${INFO}docker stop `docker ps --quiet`${NL}"
	@docker stop `docker ps --quiet`

## Kill all running containers
kill-all:
	@printf "${INFO}docker kill `docker ps --quiet | tr '\n' ' '` 2>/dev/null${NL}"
	@docker kill `docker ps --quiet | tr '\n' ' '` 2>/dev/null
	@printf "${INFO}docker rm `docker ps --all --quiet | tr '\n' ' '` 2>/dev/null${NL}"
	@docker rm `docker ps --all --quiet | tr '\n' ' '` 2>/dev/null

## Remove all unused system, images, containers, volumes and networks
clean:
	@printf "${INFO}docker system prune --force${NL}"
	@docker system prune --force
	@printf "${INFO}docker image prune --all --force${NL}"
	@docker image prune --all --force
	@printf "${INFO}docker container prune --force${NL}"
	@docker container prune --force
	@printf "${INFO}docker volume prune --force${NL}"
	@docker volume prune --force
	@printf "${INFO}docker network prune --force${NL}"
	@docker network prune --force

## Kill and remove all system, images, containers, volumes and networks
remove-all:
	-@make -s kill-all
	-@make -s clean

