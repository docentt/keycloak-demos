#!/bin/sh

. ./docker_utils.sh

./configure.sh
./stop_syslog.sh
./clear_logs.sh
docker run --name=syslog-keycloak-demos --network keycloak-demos -d -p 514:514/udp \
 -v $(pwd)/syslog/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf \
 -v $(pwd)/logs/syslog:/var/log/syslog-ng \
 --privileged \
 docker.io/balabit/syslog-ng

remove_container "keycloak-demos"
docker run --name=keycloak-demos --network keycloak-demos -d -p 8443:8443 -p 9000:9000 -p 5005:5005 \
 -v $(pwd)/realms:/opt/keycloak/data/import \
 -v $(pwd)/certs:/opt/keycloak/data/certs \
 -v $(pwd)/config/quarkus.properties:/opt/keycloak/conf/quarkus.properties \
 -v $(pwd)/config/keycloak.conf:/opt/keycloak/conf/keycloak.conf \
 -v $(pwd)/logs/keycloak:/opt/keycloak/logs \
 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
 -e JAVA_OPTS_APPEND="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -Dcom.sun.jndi.ldap.connect.pool.timeout=2000" \
 quay.io/keycloak/keycloak:26.0.7 start-dev \
 --features="preview" --import-realm --verbose \
 --hostname=https://login.example.com:8443/auth --hostname-backchannel-dynamic true --hostname-debug=true --http-relative-path=/auth \
 --hostname-admin=https://kc-admin.example.com:8443/auth --health-enabled=true --metrics-enabled=true --http-management-relative-path=/ \
 --https-port=8443 --https-certificate-file=/opt/keycloak/data/certs/keycloak-demos.crt --https-certificate-key-file=/opt/keycloak/data/certs/keycloak-demos.key \
 --truststore-paths=/opt/keycloak/data/certs/keycloak-demos.crt

SMTP=$(docker ps --filter "name=smtp-keycloak-demos")
if [ -z "${SMTP##*smtp-keycloak-demos*}" ]; then
  exit 0
fi
remove_container "smtp-keycloak-demos"
docker run --name=smtp-keycloak-demos --network keycloak-demos -d -p 5000:80 \
 -v $(pwd)/smtp/appsettings.json:/smtp4dev/appsettings.json \
 docker.io/rnwood/smtp4dev