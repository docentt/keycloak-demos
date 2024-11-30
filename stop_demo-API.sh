#!/bin/sh

. ./docker_utils.sh

stop_and_remove_container "demo-API"
stop_and_remove_container "demo-API-opa"