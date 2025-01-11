#!/bin/sh

. ./clustered_kc_utils.sh

get_node_config "$1"
exec docker logs --follow $NODE_NAME