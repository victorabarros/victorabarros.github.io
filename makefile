APP_NAME:=$(shell pwd | xargs basename)
APP_DIR=/usr/share/nginx/html
PWD=$(shell pwd)
EXPOSE_PORT=8085
BASE_DOCKER_IMAGE=nginx:alpine
APP_DOCKER_IMAGE=${APP_NAME}:latest

YELLOW=$(shell printf '\033[0;1;33m')
COLOR_OFF=$(shell printf '\033[0;1;0m')

build-image:
	@echo "${YELLOW}building docker image ${APP_DOCKER_IMAGE}${COLOR_OFF}"
	@docker build --rm . -t ${APP_DOCKER_IMAGE}

run: remove-containers
	@docker run --rm -p 80:80 --name ${APP_NAME} -d ${APP_DOCKER_IMAGE}
	@echo "${YELLOW}running at http://localhost/${COLOR_OFF}"

debug: remove-containers
	@docker run \
		-v ${PWD}:${APP_DIR}:ro \
		-p ${EXPOSE_PORT}:80 \
		--name ${APP_NAME}-debug \
		-d \
		${BASE_DOCKER_IMAGE}
	@echo "${YELLOW}running at http://localhost:${EXPOSE_PORT}/${COLOR_OFF}"

remove-containers:
ifneq ($(shell docker ps -a --filter "name=${APP_NAME}" -aq 2> /dev/null | wc -l | bc), 0)
	@echo "${YELLOW}Removing containers${COLOR_OFF}"
	@docker ps -a --filter "name=${APP_NAME}" -aq | xargs docker rm -f
endif
