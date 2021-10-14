COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_TERRAFORM = docker-compose run --rm --workdir="/opt/app/deploy" tf

.PHONY: run_build_and_push
run_build_and_push: build push

.PHONY: run_plan
run_plan: tf_init tf_plan

.PHONY: run_apply
run_apply: tf_init tf_apply

.PHONY: run_destroy_plan
run_destroy_plan: tf_init tf_destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: tf_init tf_destroy_apply

.PHONY: build
build:
	$(COMPOSE_RUN_BASH) ./scripts/build.sh

.PHONY: push
push:
	$(COMPOSE_RUN_BASH) ./scripts/push.sh


.PHONY: tf_init
tf_init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: tf_plan
tf_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

.PHONY: tf_apply
tf_apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"


.PHONY: tf_destroy_plan
tf_destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

.PHONY: tf_destroy_apply
tf_destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

.PHONY: build_self_heal
build_self_heal:
	rm -rf "dist/"
	mkdir -p dist
	docker-compose run self_healing_function_build sh \
		-c "cp -r /app/src/* /app/node_modules .; \
		apk add zip; \
		zip -rmq ./function.zip ."

.PHONY: run_self_heal
run_self_heal:
	docker-compose run self_healing_function
