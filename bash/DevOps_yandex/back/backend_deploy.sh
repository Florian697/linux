#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
EOF
echo $SPRING_DATASOURCE_URL
docker network create -d bridge sausage_network || true
docker stop backend || true && docker rm backend || true
docker login -u $GIT_user -p $GIT_pass $REGISTRY
docker pull ${REGISTRY_IMAGE}/sausage-backend:latest
set -e
docker run -d --name backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${REGISTRY_IMAGE}/sausage-backend:latest