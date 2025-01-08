variable "keycloak_url" {
  type        = string
  description = "Adres Keycloak, np. https://keycloak-demos:8443/auth"
}

variable "keycloak_realm" {
  type        = string
  description = "Realm Keycloak z poziomu którego następuje zarządzanie, np. master"
  default     = "master"
}

variable "keycloak_client_id" {
  type        = string
  description = "Nazwa konta serwisowego Keycloak"
}

variable "keycloak_client_secret" {
  type        = string
  description = "Hasło konta serwisowego Keycloak"
  sensitive   = true
}

variable "keycloak_insecure" {
  type        = bool
  description = "Czy ignorować weryfikację certyfikatu SSL"
  default     = false
}
