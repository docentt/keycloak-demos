#!/bin/sh

./dump_realms_kc.sh
docker stop keycloak-demos
docker rm keycloak-demos