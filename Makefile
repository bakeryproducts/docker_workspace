CONFIG=config/config.env
include ${CONFIG}
#export CONFIG=${CONFIG}

all: up attach

up:
	$(eval export HOST_IP := $(shell hostname -I | cut -d\  -f1))
	docker-compose -f ${COMPOSE_PATH} --env-file ${CONFIG} up --build --detach
attach:
	docker attach ${CONTAINER}
stop:
	docker-compose down
