#!/bin/sh

docker run --name=keycloak-24 -d -p 8080:8080 -p 5005:5005 \
 -v ./realms:/opt/keycloak/data/import \
 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin \
 -e KC_HOSTNAME=localhost -e KC_HOSTNAME_STRICT_HTTPS=false \
 -e JAVA_OPTS_APPEND="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005" \
 quay.io/keycloak/keycloak:24.0.5 start-dev --import-realm --http-relative-path=/auth