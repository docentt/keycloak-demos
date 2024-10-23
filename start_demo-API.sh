#!/bin/sh

./stop_demo-API.sh
docker run --name=demo-API --network keycloak-demos -d -p 9443:9443 \
  -v $(pwd)/certs/keycloak-demos.crt:/certs/keycloak-demos.crt \
  -v $(pwd)/certs/keycloak-demos.key:/certs/keycloak-demos.key \
  -v $(pwd)/demo-API/server/demo-API.pl:/app/demo-API.pl \
  -e OPA_URL=http://demo-API-opa:8181/v1/data/auth/policy_evaluation \
  keycloak-demos/demo-api \
  plackup --port 9443 --host 0.0.0.0 \
  --enable-ssl --ssl-cert-file=/certs/keycloak-demos.crt --ssl-key-file=/certs/keycloak-demos.key /app/demo-API.pl

docker run --name=demo-API-opa --network keycloak-demos -d -p 8181:8181 \
  -v $(pwd)/demo-API/opa/auth.rego:/auth.rego \
  -v $(pwd)/demo-API/opa/config.rego:/config.rego \
  -v $(pwd)/certs/keycloak-demos.crt:/keycloak-demos.crt \
  openpolicyagent/opa:latest-debug run --server \
  --log-level debug --log-format json-pretty \
  /auth.rego /config.rego