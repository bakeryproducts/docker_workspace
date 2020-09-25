CONFIG=config.env
include ${CONFIG}

all: image

run:
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} up --build
image:
	echo ${CONFIG}
	docker-compose -f ${COMPOSE_PATH} --env-file ./config.env up --build
stop:
	docker-compose down
