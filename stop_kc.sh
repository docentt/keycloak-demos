#!/bin/sh

docker stop keycloak-demos
./dump_realms_kc.sh
docker rm keycloak-demos