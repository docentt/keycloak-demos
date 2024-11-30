#!/bin/sh

smtp_restart=false
no_dump=false

while [ $# -gt 0 ]; do
  case "$1" in
    --smtp-restart)
      smtp_restart=true
      shift
      ;;
    --no-dump)
      no_dump=true
      shift
      ;;
    --help)
      echo "Użycie: $0 [opcje]"
      echo
      echo "Dostępne opcje:"
      echo "  --smtp-restart    Zrestartuje serwer pocztowy"
      echo "  --no-dump         Nie wykonuje zrzutu konfiguracji"
      exit 0
      ;;
    *)
      echo "Nieznana opcja: $1"
      echo "Użyj $0 --help, aby zobaczyć dostępne opcje."
      exit 1
      ;;
  esac
done

if [ "$no_dump" = true ]; then
  ./stop_kc.sh  --no-dump
else
  ./stop_kc.sh
fi
if [ "$smtp_restart" = true ]; then
  ./stop_smtp.sh
fi
./start_kc.sh
