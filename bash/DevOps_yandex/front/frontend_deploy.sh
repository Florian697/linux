#!/bin/bash
set +e
EOF
docker network create -d bridge sausage_network || true
docker stop frontend || true && docker rm frontend || true
docker login -u $GIT_user -p $GIT_pass $REGISTRY
docker pull ${REGISTRY_IMAGE}/sausage-frontend:latest
set -e
docker run -d --name frontend \
    --network=sausage_network -p8080:80 \
    --restart always \
    --pull always \
    --env-file .env \
    ${REGISTRY_IMAGE}/sausage-frontend:latest