#!/bin/sh

get_node_config() {
  case $1 in
    1) NODE_NAME="keycloak-demos-clustered-node-1"; NODE_PORT=9001 ;;
    2) NODE_NAME="keycloak-demos-clustered-node-2"; NODE_PORT=9002 ;;
    3) NODE_NAME="keycloak-demos-clustered-node-3"; NODE_PORT=9003 ;;
    *) echo "Invalid node number: $1. Supported nodes: 1-3."; exit 1 ;;
  esac
  echo "Node: $NODE_NAME, Management port: $NODE_PORT"
}

start_keycloak_cluster_node() {
  NODE_NAME=$1
  MGMT_PORT_EXPOSED=$2
  docker run --name=${NODE_NAME} --network keycloak-demos -d -p ${MGMT_PORT_EXPOSED}:9000 \
   -e KC_DB=postgres \
   -e KC_DB_URL=jdbc:postgresql://db-keycloak-demos-clustered:5432/keycloak \
   -e KC_DB_USERNAME=keycloak \
   -e KC_DB_PASSWORD=keycloak \
   -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
   -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
   -e KC_HOSTNAME_STRICT=false \
   -v $(pwd)/config/quarkus.properties:/opt/keycloak/conf/quarkus.properties \
   quay.io/keycloak/keycloak:26.0.7 start \
   --proxy-headers=xforwarded --spi-sticky-session-encoder-infinispan-should-attach-route=false \
   --hostname=https://login.example.com/auth --http-enabled=true --hostname-debug=true --http-relative-path=/auth \
   --health-enabled=true --metrics-enabled=true --cache-metrics-histograms-enabled=true --http-management-relative-path=/
}