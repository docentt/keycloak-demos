#!/bin/sh

. ./docker_utils.sh

if [ $# -eq 0 ]; then
  CMD="apply -auto-approve"
else
  CMD="$@"
fi

if is_container_running "keycloak-demos"; then
  docker run --rm --network keycloak-demos -e TF_VAR_keycloak_url="https://keycloak-demos:8443/auth" \
    -e TF_VAR_keycloak_client_id="service-account_terraform-provider-keycloak" \
    -e TF_VAR_keycloak_client_secret="service-account_terraform-provider-keycloak-secret" \
    -e TF_VAR_keycloak_insecure="true" \
    -v "$(pwd)/config/terraform-provider-keycloak:/terraform" \
    --entrypoint /bin/sh -w /terraform \
    hashicorp/terraform:latest -c "terraform init && terraform $CMD"
else
  echo "Wymagane uruchomienie keycloak-demos (należy wykonać ./start_kc.sh)."
fi