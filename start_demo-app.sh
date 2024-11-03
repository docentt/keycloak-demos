#!/bin/sh

./stop_demo-app.sh
docker run --name=demo-app --network keycloak-demos -d -p 443:443 \
  -v $(pwd)/certs/keycloak-demos.crt:/etc/ssl/certs/keycloak-demos.crt \
  -v $(pwd)/certs/keycloak-demos.key:/etc/ssl/private/keycloak-demos.key \
  -v $(pwd)/demo-app/nginx/nginx.conf:/etc/nginx/nginx.conf \
  keycloak-demos/demo-app