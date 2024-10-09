#!/bin/sh

if ! docker network ls --format '{{.Name}}' | grep -wq "keycloak-demos"; then
  docker network create -d bridge keycloak-demos
fi
NET=$(docker network inspect keycloak-demos | grep -oP '"Subnet": "\K\d+\.\d+\.\d+\.')
echo "Configuring for network ${NET}0"
cp template-realms/*.json realms/.
sed -i -r "s/172\.18\.0\.([0-9]+)/${NET}\1/g" realms/*
