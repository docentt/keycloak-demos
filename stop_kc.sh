#!/bin/sh

. ./docker_utils.sh

stop_container "keycloak-demos"
if [ "$1" != "--no-dump" ]; then
  ./dump_realms_kc.sh
else
  echo "Pomijam wykonanie zrzutu konfiguracji."
fi
remove_container "keycloak-demos"
./stop_syslog.sh