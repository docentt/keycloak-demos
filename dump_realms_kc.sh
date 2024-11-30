#!/bin/sh

. ./docker_utils.sh
CONTAINER_NAME="keycloak-demos"
DUMP_CONTAINER_NAME="${CONTAINER_NAME}-dump"
currentTime=$(date "+%Y.%m.%d-%H.%M.%S")

if is_container_exited "$CONTAINER_NAME"; then
    remove_container "$DUMP_CONTAINER_NAME"
    remove_image "$DUMP_CONTAINER_NAME"

    docker commit "$CONTAINER_NAME" "$DUMP_CONTAINER_NAME"

    mkdir DUMPS/$currentTime
    docker run --name=$DUMP_CONTAINER_NAME --network keycloak-demos -v $(pwd)/DUMPS/$currentTime:/opt/keycloak/DUMP --entrypoint /opt/keycloak/bin/kc.sh $DUMP_CONTAINER_NAME export --dir /opt/keycloak/DUMP

    remove_container "$DUMP_CONTAINER_NAME"
    remove_image "$DUMP_CONTAINER_NAME"
else
    echo "Not dumping, '$CONTAINER_NAME' is either running or does not exist."
fi