APP_NAME:=$(shell pwd | xargs basename)
APP_DIR=/usr/share/nginx/html
PWD=$(shell pwd)
EXPOSE_PORT=8085
BASE_DOCKER_IMAGE=nginx:alpine
APP_DOCKER_IMAGE=${APP_NAME}-nginx
GCP_ARTIFACT_REGISTRY=us-central1-docker.pkg.dev/barros-engineer/victorabarros-github-io

YELLOW=$(shell printf '\033[0;1;33m')
COLOR_OFF=$(shell printf '\033[0;1;0m')

build-image:
	@echo "${YELLOW}building docker image ${APP_DOCKER_IMAGE}${COLOR_OFF}"
	@docker build --rm . -t ${APP_DOCKER_IMAGE}

run: remove-containers
	@docker run --rm -p ${EXPOSE_PORT}:80 --name ${APP_NAME} -d ${APP_DOCKER_IMAGE}
	@echo "${YELLOW}running at http://localhost:${EXPOSE_PORT}/${COLOR_OFF}"

debug: remove-containers
	@docker run -v ${PWD}:${APP_DIR}:ro -p ${EXPOSE_PORT}:80 --name ${APP_NAME}-debug -d ${BASE_DOCKER_IMAGE}
	@echo "${YELLOW}running at http://localhost:${EXPOSE_PORT}/${COLOR_OFF}"

build-amd64-image:
	@docker buildx build --platform linux/amd64 --rm . -t ${APP_DOCKER_IMAGE}-amd64

tag-amd64-image:
	@docker tag ${APP_DOCKER_IMAGE}-amd64 \
		${GCP_ARTIFACT_REGISTRY}/${APP_DOCKER_IMAGE}:${TAG}

push-image: build-amd64-image tag-amd64-image
	@docker push ${GCP_ARTIFACT_REGISTRY}/${APP_DOCKER_IMAGE}:${TAG}

remove-containers:
ifneq ($(shell docker ps -a --filter "name=${APP_NAME}" -aq 2> /dev/null | wc -l | bc), 0)
	@echo "${YELLOW}Removing containers${COLOR_OFF}"
	@docker ps -a --filter "name=${APP_NAME}" -aq | xargs docker rm -f
endif
