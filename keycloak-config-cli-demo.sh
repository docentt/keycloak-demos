#!/bin/sh

. ./docker_utils.sh

if is_container_running "keycloak-demos"; then
  docker run --rm --network keycloak-demos -e KEYCLOAK_URL=https://keycloak-demos:8443/auth \
      -e KEYCLOAK_USER=admin \
      -e KEYCLOAK_PASSWORD=admin \
      -e KEYCLOAK_SSLVERIFY=false \
      -e LOGGING_LEVEL_ROOT=info \
      -e IMPORT_VARSUBSTITUTION_ENABLED=false \
      -e IMPORT_MANAGED_GROUP=full \
      -e IMPORT_MANAGED_CLIENTSCOPE=no-delete \
      -e IMPORT_MANAGED_CLIENT=full \
      -e IMPORT_PATH=/config \
      -v $(pwd)/config/keycloak-config-cli:/config \
      quay.io/adorsys/keycloak-config-cli:latest-26.0.5
else
  echo "Wygagane uruchomienie keycloak-demos (należy wykonać ./start_kc.sh)."
fi