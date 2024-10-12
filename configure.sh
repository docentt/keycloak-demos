#!/bin/sh

if ! docker network ls --format '{{.Name}}' | grep -wq "keycloak-demos"; then
  docker network create -d bridge keycloak-demos
fi
