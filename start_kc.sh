#!/bin/sh

./configure.sh
docker rm keycloak-demos
docker run --name=keycloak-demos --network keycloak-demos -d -p 8443:8443 -p 5005:5005 \
 -v $(pwd)/realms:/opt/keycloak/data/import \
 -v $(pwd)/certs:/opt/keycloak/data/certs \
 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin \
 -e JAVA_OPTS_APPEND="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005" \
 quay.io/keycloak/keycloak:26.0.5 start-dev \
 --features="preview" --import-realm --verbose \
 --hostname=https://login.example.com:8443/auth --hostname-backchannel-dynamic true --http-relative-path=/auth \
 --https-port=8443 --https-certificate-file=/opt/keycloak/data/certs/keycloak-demos.crt --https-certificate-key-file=/opt/keycloak/data/certs/keycloak-demos.key \
 --truststore-paths=/opt/keycloak/data/certs/keycloak-demos.crt

SMTP=$(docker ps --filter "name=smtp-keycloak-demos")
if [ -z "${SMTP##*smtp-keycloak-demos*}" ]; then
  exit 0
fi
docker rm smtp-keycloak-demos
docker run --name=smtp-keycloak-demos --network keycloak-demos -d -p 5000:80 \
 -v $(pwd)/smtp/appsettings.json:/smtp4dev/appsettings.json \
 rnwood/smtp4dev