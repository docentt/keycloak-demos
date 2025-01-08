resource "keycloak_realm" "terraform-provider-keycloak-demo_realm" {
  realm   = "terraform-provider-keycloak-demo"
  enabled = true

  internationalization {
    supported_locales = [
      "en",
      "pl"
    ]
    default_locale    = "pl"
  }

  attributes = {
    userProfileEnabled = true
  }
}

resource "keycloak_realm_events" "terraform-provider-keycloak-demo_realm_events" {
  realm_id = keycloak_realm.terraform-provider-keycloak-demo_realm.id

  admin_events_enabled         = true
  admin_events_details_enabled = true

  events_listeners = [
    "jboss-logging"
  ]
}

resource "keycloak_realm_user_profile" "terraform-provider-keycloak-demo_user_profile" {
  realm_id = keycloak_realm.terraform-provider-keycloak-demo_realm.id

# Wsparcie wkrótce
#  unmanaged_attribute_policy = "ENABLED"

  attribute {
    name         = "username"
    display_name = "$${username}"

    required_for_roles  = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        min = 3
        max = 255
      }
    }
    validator {
      name = "username-prohibited-characters"
    }
    validator {
      name = "up-username-not-idn-homograph"
    }
  }

  attribute {
    name         = "email"
    display_name = "$${email}"

    required_for_roles  = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "email"
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }
  }

  attribute {
    name         = "firstName"
    display_name = "$${firstName}"

    required_for_roles  = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }

    validator {
      name = "person-name-prohibited-characters"
    }
  }

  attribute {
    name         = "lastName"
    display_name = "$${lastName}"

    required_for_roles  = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }

    validator {
      name = "person-name-prohibited-characters"
    }
  }

  group {
    name               = "user-metadata"
    display_header     = "User metadata"
    display_description = "Attributes, which refer to user metadata"
  }
}