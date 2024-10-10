#!/bin/sh

./stop_kc.sh "$@"
if [ "$1" = "--smtp-restart" ]; then
  ./stop_smtp.sh
fi
./start_kc.sh
