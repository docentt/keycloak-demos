#!/bin/sh

KC24=$(docker ps --filter "name=keycloak-demos")
currentTime=$(date "+%Y.%m.%d-%H.%M.%S")

if [ -z ""${KC24##*keycloak-24*} ]; then
	docker exec keycloak-24 rm -rf /opt/keycloak/DUMP
	docker exec keycloak-24 mkdir /opt/keycloak/DUMP
	docker exec keycloak-24 /bin/sh -c 'export JAVA_OPTS_APPEND="" && /opt/keycloak/bin/kc.sh export --dir /opt/keycloak/DUMP'
	docker cp keycloak-24:/opt/keycloak/DUMP .
	mv DUMP DUMPS/$currentTime
else
	echo "Not dumping, keycloak-demos is not running"
fi