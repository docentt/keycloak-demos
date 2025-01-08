resource "keycloak_group" "group_1" {
  realm_id = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name     = "Group 1"
}

resource "keycloak_group" "group_1_subgroup_1" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name      = "SubGroup 1"
  parent_id = keycloak_group.group_1.id
}

resource "keycloak_group" "group_1_subgroup_2" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name      = "SubGroup 2"
  parent_id = keycloak_group.group_1.id
}

resource "keycloak_group" "group_2" {
  realm_id = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name     = "Group 2"
}

resource "keycloak_group" "group_2_subgroup_1" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name      = "SubGroup 1"
  parent_id = keycloak_group.group_2.id
}

resource "keycloak_group" "group_2_subgroup_2" {
  realm_id  = keycloak_realm.terraform-provider-keycloak-demo_realm.id
  name      = "SubGroup 2"
  parent_id = keycloak_group.group_2.id
}