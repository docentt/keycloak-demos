terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 4.5.0"
    }
  }
}

provider "keycloak" {
  url                      = var.keycloak_url
  realm                    = var.keycloak_realm
  client_id                = var.keycloak_client_id
  client_secret            = var.keycloak_client_secret
  tls_insecure_skip_verify = var.keycloak_insecure
}