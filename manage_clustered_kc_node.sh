#!/bin/sh

. ./docker_utils.sh
. ./clustered_kc_utils.sh

stop_node() {
  get_node_config "$1"
  if is_container_running "$NODE_NAME"; then
    echo "Stopping node..."
    stop_and_remove_container "$NODE_NAME"
  else
    echo "The node is not running."
  fi
}

start_node() {
  get_node_config "$1"
  if is_container_running "$NODE_NAME"; then
    echo "The node is already running."
  else
    echo "Starting node..."
    start_keycloak_cluster_node "$NODE_NAME" "$NODE_PORT"
  fi
}

restart_node() {
  get_node_config "$1"
  echo "Restarting node..."
  stop_and_remove_container "$NODE_NAME"
  start_keycloak_cluster_node "$NODE_NAME" "$NODE_PORT"
}

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <start|stop|restart> <node_number>"
  exit 1
fi

ACTION=$1
NODE_NUM=$2

case $ACTION in
  start)
    start_node "$NODE_NUM"
    ;;
  stop)
    stop_node "$NODE_NUM"
    ;;
  restart)
    restart_node "$NODE_NUM"
    ;;
  *)
    echo "Unknown action: $ACTION. Allowed actions: start, stop, restart."
    exit 1
    ;;
esac