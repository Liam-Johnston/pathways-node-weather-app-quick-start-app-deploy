#!/bin/bash -eu

REPOSITORY_URL=$(aws ssm get-parameter --name "/${USERNAME}/${PROJECT_NAME}/ecr_repository_url" --output json | jq -r '.Parameter.Value')
REPOSITORY_SERVER=$(cut -d '/' -f1 <<<$REPOSITORY_URL)

aws ecr get-login-password | docker login --username AWS --password-stdin $REPOSITORY_SERVER
docker tag $IMAGE_NAME $REPOSITORY_URL:1
docker push $REPOSITORY_URL:1
