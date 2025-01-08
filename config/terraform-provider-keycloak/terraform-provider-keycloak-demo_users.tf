resource "keycloak_user" "test_user" {
  realm_id       = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  enabled        = true
  username       = "test"
  email          = "test@example.com"
  email_verified = true
  first_name     = "Managed Test"
  last_name      = "User"

  initial_password {
    value     = "test"
    temporary = false
  }

  attributes = {
    locale       = "pl"
    #W wersji 4.5.0 wymaga jeszcze ręcznych zmian w konfiguracji Keycloak
    demo_company = "example.com"
    #W wersji 4.5.0 wymaga jeszcze ręcznych zmian w konfiguracji Keycloak
    demo_hobby   = "movies##computer games##travelling"
  }
}

resource "keycloak_user_groups" "test_user_groups" {
  realm_id = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  user_id  = keycloak_user.test_user.id

  group_ids = [
    keycloak_group.group_1_subgroup_1.id,
    keycloak_group.group_2_subgroup_2.id
  ]
}
