#!/bin/sh

KC=$(docker ps --filter "name=keycloak-demos")
currentTime=$(date "+%Y.%m.%d-%H.%M.%S")

if [ -z ""${KC##*keycloak-demos*} ]; then
	docker exec keycloak-demos rm -rf /opt/keycloak/DUMP
	docker exec keycloak-demos mkdir /opt/keycloak/DUMP
	docker exec keycloak-demos /bin/sh -c 'export JAVA_OPTS_APPEND="" && /opt/keycloak/bin/kc.sh export --dir /opt/keycloak/DUMP'
	docker cp keycloak-demos:/opt/keycloak/DUMP .
	mv DUMP DUMPS/$currentTime
else
	echo "Not dumping, keycloak-demos is not running"
fi