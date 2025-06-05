#!/bin/bash

which docker || exit 1

CONTAINER_NAME=keycloak-demo-idp

#  - name: keycloak-one
#    image: quay.io/keycloak/keycloak:latest
#    args:
#      - start-dev
#    ports:
#      - name: kc-container
#        containerPort: 8080
#    env:
#      - name: KC_BOOTSTRAP_ADMIN_USERNAME
#        value: admin
#      - name: KC_BOOTSTRAP_ADMIN_PASSWORD
#        value: admin
#      - name: KC_DB
#        value: dev-mem
#      - name: KC_LOG_LEVEL
#        value: DEBUG

containerId=$(docker ps | grep "${CONTAINER_NAME}" | awk '{print $1}')
if [ "${containerId}" != "" ] ; then
  echo "${CONTAINER_NAME} is running in container ${containerId}"
  exit
fi

docker run \
  --name "${CONTAINER_NAME}" \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  -e KC_DB=dev-mem \
  -e KC_LOG_LEVEL=DEBUG \
  -e KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/server.crt.pem \
  -e KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/server.key.pem \
  -v ./server.crt.pem:/opt/keycloak/conf/server.crt.pem \
  -v ./server.key.pem:/opt/keycloak/conf/server.key.pem \
  -d -p 8443:8443 \
  quay.io/keycloak/keycloak:latest \
  start-dev

echo "${0} Done."
