#!/bin/sh

./dump_realms_kc_24.sh
docker stop keycloak-24
docker rm keycloak-24