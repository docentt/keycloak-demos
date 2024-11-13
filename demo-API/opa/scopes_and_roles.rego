package scopes_and_roles

import rego.v1

#Polityki dot. operacji na endpointach
endpoint_access := [
    {"method": "GET", "path": "/public", "required_scopes": [], "required_roles": [], "required_client_roles": [], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/profile", "required_scopes": ["profile.read"], "required_roles": [], "required_client_roles": [], "aud": "https://api.example.com"},
    {"method": "PUT", "path": "/profile", "required_scopes": ["profile.update"], "required_roles": [], "required_client_roles": [], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/data/{id}", "required_scopes": ["data.read"], "required_roles": [], "required_client_roles": [], "aud": "https://api.example.com"},
    {"method": "PUT", "path": "/data/{id}", "required_scopes": ["data.update"], "required_roles": [], "required_client_roles": [], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/data/export", "required_scopes": ["data.export"], "required_roles": [], "required_client_roles": [], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/config", "required_scopes": ["admin.config"], "required_roles": [], "required_client_roles": [], "aud": "https://api.admin.example.com"},
    {"method": "PUT", "path": "/config", "required_scopes": ["admin.config"], "required_roles": [], "required_client_roles": [], "aud": "https://api.admin.example.com"},
    {"method": "POST", "path": "/policies", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["policy-create"], "aud": "https://api.example.org"},
    {"method": "GET", "path": "/policies/{id}", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["policy-read"], "aud": "https://api.example.org"},
    {"method": "PUT", "path": "/policies/{id}", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["policy-update"], "aud": "https://api.example.org"},
    {"method": "POST", "path": "/claims", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["claim-create"], "aud": "https://api.example.org"},
    {"method": "GET", "path": "/claims", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["claim-read"], "aud": "https://api.admin.example.org"},
    {"method": "POST", "path": "/claims/{id}/approve", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["claim-approve"], "aud": "https://api.admin.example.org"},
    {"method": "POST", "path": "/claims/{id}/reject", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["claim-reject"], "aud": "https://api.admin.example.org"},
    {"method": "POST", "path": "/claims/{id}/process", "required_scopes": [ ], "required_roles": [], "required_client_roles": ["claim-process"], "aud": "https://api.internal.example.org"}
]

#Przypasowanie polityki dot. operacji na endpointach do zakresów w tokenie
check_scopes(endpoint_access_policy, token_scopes) if {
	token_scopes_set := {scope | scope = token_scopes[_]}
    every endpoint_scope in endpoint_access_policy.required_scopes {
    	some token_scope in token_scopes_set
        token_scope = endpoint_scope
    }
}

#Przypasowanie polityki dot. operacji na endpointach do ról klienckich lub globalnych w tokenie
check_roles(endpoint_access_policy_required_roles, token_roles) if {
	token_roles_set := {role | role = token_roles[_]}
    every endpoint_role in endpoint_access_policy_required_roles {
    	some token_role in token_roles_set
        token_role = endpoint_role
    }
}

exact_match_regex(path) = exact_match_regex_pattern if {
    exact_match_regex_pattern := concat("", ["^", regex.replace(path, "{[^/}]+}", "[0-9a-fA-F-]+"), "$"])
}