COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_TERRAFORM = docker-compose run --rm --workdir="/opt/app/deploy" tf

APP_NAME=weather-app
PROJECT_NAME=pathwaysdojo
USERNAME=liamjohnston

IMAGE_VERSION=1
IMAGE_NAME=$(APP_NAME):$(IMAGE_VERSION)

.PHONY: run_build_and_push
run_build_and_push: build push

.PHONY: run_plan
run_plan: tf_init tf_plan

.PHONY: run_apply
run_apply: tf_init tf_apply


.PHONY: build
build:
	cd ./weather-app && docker build -t $(IMAGE_NAME) -f weather-app-dockerfile .

.PHONY: push
push:
	$(COMPOSE_RUN_BASH) 'IMAGE_NAME=$(IMAGE_NAME) scripts/push.sh'


.PHONY: tf_init
tf_init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: tf_plan
tf_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

.PHONY: tf_apply
tf_apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"
