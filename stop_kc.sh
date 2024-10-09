#!/bin/sh

docker stop keycloak-demos
if [ "$1" != "--no-dump" ]; then
  ./dump_realms_kc.sh
else
  echo "Pomijam wykonanie zrzutu konfiguracji."
fi
docker rm keycloak-demos