#!/bin/sh

./configure.sh
docker run --name=keycloak-demos --network keycloak-demos -d -p 8080:8080 -p 5005:5005 \
 -v $(pwd)/realms:/opt/keycloak/data/import \
 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin \
 -e KC_HOSTNAME=localhost -e KC_HOSTNAME_STRICT_HTTPS=false \
 -e JAVA_OPTS_APPEND="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005" \
 quay.io/keycloak/keycloak:26.0.0 start-dev --features="preview" --import-realm --http-relative-path=/auth