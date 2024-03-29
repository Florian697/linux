#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo rm -f /home/jarservice/sausage-store.jar||true
#Переносим артефакт в нужную папку
curl --insecure -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}/sausage-store-butkevich-mikhail-backend/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
sudo cp ./sausage-store.jar /home/jarservice/sausage-store.jar||true #"<...>||true" говорит, если команда обвалится — продолжай
sudo chmod 777 /home/jarservice/sausage-store.jar
sudo chown jarservice:jarservice /home/jarservice/sausage-store.jar
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend