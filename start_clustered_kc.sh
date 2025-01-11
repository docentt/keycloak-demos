#!/bin/sh

. ./docker_utils.sh
. ./clustered_kc_utils.sh

./configure.sh
./stop_syslog.sh
./clear_logs.sh

remove_container "db-keycloak-demos-clustered"
remove_container "keycloak-demos-clustered-node-1"
remove_container "keycloak-demos-clustered-node-2"
remove_container "keycloak-demos-clustered-node-3"
remove_container "haproxy-keycloak-clustered-demos"

if is_container_running "db-keycloak-demos-clustered"; then
  echo "PostgreSQL is already running."
else
  echo "Initializing PostgreSQL..."

  docker run --name=db-keycloak-demos-clustered --network keycloak-demos -d \
   -e POSTGRES_DB=keycloak \
   -e POSTGRES_USER=keycloak \
   -e POSTGRES_PASSWORD=keycloak \
   -v $(pwd)/clustered/postgresql/data/:/var/lib/postgresql/data \
   docker.io/postgres:15
fi

echo "Initializing Syslog..."

docker run --name=syslog-keycloak-demos --network keycloak-demos -d -p 514:514/udp \
 -v $(pwd)/syslog/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf \
 -v $(pwd)/logs/syslog:/var/log/syslog-ng \
 --privileged \
 docker.io/balabit/syslog-ng

echo "Initializing Keycloak nodes..."

./manage_clustered_kc_node.sh start 1
./manage_clustered_kc_node.sh start 2
./manage_clustered_kc_node.sh start 3

if is_container_running "haproxy-keycloak-clustered-demos"; then
  echo "HAProxy is already running."
else
  echo "Initializing HAProxy..."

  cat certs/keycloak-demos.crt certs/keycloak-demos.key > certs/keycloak-demos.pem
  docker run --name haproxy-keycloak-clustered-demos --network keycloak-demos -d -p 443:443 -p 8080:8080 \
      -v $(pwd)/config/clustered/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg \
      -v $(pwd)/certs:/etc/ssl/certs \
      docker.io/haproxy:latest
fi