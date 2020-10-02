CONFIG=config.env
include ${CONFIG}

all: up attach

up:
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} up --build --detach
attach:
	docker attach ${CONTAINER}
stop:
	docker-compose down
