#!/bin/sh

stop_container() {
  local container_name="$1"

  if docker ps --filter "name=^/${container_name}$" --filter "status=running" --format "{{.Names}}" | grep -q "^${container_name}$"; then
    docker stop "$container_name"
  fi
}

remove_container() {
  local container_name="$1"

  if docker ps -a --filter "name=^/${container_name}$" --filter "status=exited" --format "{{.Names}}" | grep -q "^${container_name}$"; then
    docker rm "$container_name"
  fi
}

stop_and_remove_container() {
  local container_name="$1"

  stop_container $1
  remove_container $1
}

is_container_running() {
  local container_name="$1"

  if docker ps --filter "name=^/${container_name}$" --filter "status=running" --format "{{.Names}}" | grep -q "^${container_name}$"; then
    return 0
  else
    return 1
  fi
}

is_container_exited() {
  local container_name="$1"
  docker ps -a --filter "name=^/${container_name}$" --filter "status=exited" --format "{{.Names}}" | grep -q "^${container_name}$"
}

does_image_exist() {
  local image_name="$1"

  if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${image_name}$"; then
    return 0
  else
    return 1
  fi
}

remove_image() {
  local image_name="$1"
  if does_image_exist "$image_name"; then
    docker rmi "$image_name"
  fi
}