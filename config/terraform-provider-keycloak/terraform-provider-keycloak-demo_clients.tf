resource "keycloak_openid_client_scope" "demo_scope_001" {
  realm_id    = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name        = "demo_client_scope_001"
  description = "Demo Company related info"
  consent_screen_text = "Info on your Demo Company"
  include_in_token_scope = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "demo_scope_001_mapper_company" {
  realm_id        = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  client_scope_id = keycloak_openid_client_scope.demo_scope_001.id

  name           = "Company"
  user_attribute = "demo_company"
  claim_name     = "demo_company"

  add_to_userinfo     = true
  add_to_id_token     = true
  add_to_access_token = true
  claim_value_type     = "String"
  multivalued         = false
}

resource "keycloak_openid_client_scope" "demo_scope_002" {
  realm_id    = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name        = "demo_client_scope_002"
  description = "Demo Hobby related info"
  consent_screen_text = "Info on your Demo Hobby"
  include_in_token_scope     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "demo_scope_002_mapper_hobby" {
  realm_id        = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  client_scope_id = keycloak_openid_client_scope.demo_scope_002.id

  name           = "Demo hobby"
  user_attribute = "demo_hobby"
  claim_name     = "demo_hobby"

  add_to_userinfo     = true
  add_to_id_token     = true
  add_to_access_token = true
  claim_value_type     = "String"
  multivalued         = true
}

resource "keycloak_openid_client" "oidc_debugger" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  client_id = "https://oidcdebugger.com/"

  name          = "OIDC Debugger"
  description   = "OIDC Debugger"
  enabled       = true
  access_type   = "CONFIDENTIAL"
  consent_required = true

  standard_flow_enabled  = false
  implicit_flow_enabled  = true
  direct_access_grants_enabled = false

  valid_redirect_uris = [
    "https://oidcdebugger.com/debug"
  ]
  web_origins = [
    "https://oidcdebugger.com"
  ]
}

resource "keycloak_openid_client_default_scopes" "oidc_debugger_default_scopes" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  client_id = keycloak_openid_client.oidc_debugger.id

  default_scopes = [
    "web-origins",
    "acr",
    "roles",
    "profile",
    "email",
    keycloak_openid_client_scope.demo_scope_001.name
  ]
}

resource "keycloak_openid_client_optional_scopes" "oidc_debugger_optional_scopes" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  client_id = keycloak_openid_client.oidc_debugger.id

  optional_scopes = [
    keycloak_openid_client_scope.demo_scope_002.name
  ]
}