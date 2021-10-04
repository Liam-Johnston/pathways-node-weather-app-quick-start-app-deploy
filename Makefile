COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf

.PHONY: run_build_and_push
run_build_and_push: build push

.PHONY: build
build:
	$(COMPOSE_RUN_BASH) scripts/build.sh

.PHONY: push
push:
	$(COMPOSE_RUN_BASH) scripts/push.sh
