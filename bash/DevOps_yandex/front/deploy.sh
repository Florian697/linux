#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo rm -f /var/www-data/dist/frontend||true
sudo rm -f ./sausage-store.tar.gz||true
#Переносим артефакт в нужную папку
curl --insecure -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.tar.gz ${NEXUS_REPO_URL}/sausage-store-butkevich-mikhail-backend/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.tar.gz
sudo tar xvzf ./sausage-store.tar.gz -C /var/www-data/dist/frontend||true #"<...>||true" говорит, если команда обвалится — продолжай
cd /var/www-data/dist/frontend
sudo npm install
sudo npm run build
cd /var/www-data/dist/frontend && sudo npm install -g http-server
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-frontend