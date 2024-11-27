#!/bin/bash

LDAP_HOST="ldap://localhost"
LDAP_USER="cn=admin,dc=example,dc=org"
LDAP_PASS="admin"
BASE_DN="cn=Connections,cn=Monitor"

CONNECTIONS=$(ldapsearch -x -H $LDAP_HOST -D $LDAP_USER -w $LDAP_PASS -b $BASE_DN "(objectClass=monitorConnection)" \
  | grep -c "^dn: cn=Connection")

echo "LICZBA UTRZYMYWANYCH POŁĄCZEŃ: $((CONNECTIONS - 1))"