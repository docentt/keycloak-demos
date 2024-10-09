#!/bin/sh

KC=$(docker ps -a --filter "name=keycloak-demos")
currentTime=$(date "+%Y.%m.%d-%H.%M.%S")

if [ -z ""${KC##*keycloak-demos*} ]; then
  docker commit keycloak-demos keycloak-demos-dump
  mkdir DUMPS/$currentTime
  docker run --name=keycloak-demos-dump -v ./DUMPS/$currentTime:/opt/keycloak/DUMP --entrypoint /opt/keycloak/bin/kc.sh keycloak-demos-dump export --dir /opt/keycloak/DUMP
	docker rm keycloak-demos-dump
	docker rmi keycloak-demos-dump
else
	echo "Not dumping, keycloak-demos is still running"
fi