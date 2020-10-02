CONFIG=config.env
include ${CONFIG}

all: build

build:
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} build
run:
	docker-compose run --name ${CONTAINER} ${IMAGE}
up:
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} up --build --detach
	docker attach ${CONTAINER}
stop:
	docker-compose down
