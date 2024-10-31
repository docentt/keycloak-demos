#!/bin/sh

./stop_ldap.sh
docker run --name ldap-keycloak-demos --network keycloak-demos -d -p 389:389 \
  -v $(pwd)/LDAP/keycloak-demos.ldif:/ldifs/keycloak-demos.ldif \
  -e LDAP_PORT_NUMBER="389" \
  -e LDAP_ADMIN_PASSWORD="admin" \
  -e LDAP_LOGLEVEL="1" \
  bitnami/openldap:latest