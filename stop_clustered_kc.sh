#!/bin/bash

. ./docker_utils.sh

./manage_clustered_kc_node.sh stop 1
./manage_clustered_kc_node.sh stop 2
./manage_clustered_kc_node.sh stop 3
./stop_syslog.sh
stop_and_remove_container "haproxy-keycloak-clustered-demos"
stop_and_remove_container "db-keycloak-demos-clustered"