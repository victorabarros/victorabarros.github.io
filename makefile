APP_NAME?=victorabarros.github.io
APP_DIR=/usr/share/nginx/html
PWD=$(shell pwd)
PORT=8085
DOCKER_IMAGE=nginx:1.27-alpine

YELLOW=$(shell printf '\033[0;1;33m')
COLOR_OFF=$(shell printf '\033[0;1;0m')

run: remove-containers
	@docker run \
		-v ${PWD}:${APP_DIR}:ro \
		-p ${PORT}:80 \
		--name ${APP_NAME} \
		-d \
		${DOCKER_IMAGE}
	@echo "${YELLOW}running at http://localhost:8085/${COLOR_OFF}"
	

remove-containers:
ifneq ($(shell docker ps -a --filter "name=${APP_NAME}" -aq 2> /dev/null | wc -l | bc), 0)
	@echo "${YELLOW}Removing containers${COLOR_OFF}"
	@docker ps -a --filter "name=${APP_NAME}" -aq | xargs docker rm -f
endif
