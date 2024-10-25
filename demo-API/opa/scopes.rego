package scopes

import rego.v1

#Polityki dot. operacji na endpointach
endpoint_access := [
    {"method": "GET", "path": "/public", "required_scopes": [], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/profile", "required_scopes": ["profile.read"], "aud": "https://api.example.com"},
    {"method": "PUT", "path": "/profile", "required_scopes": ["profile.update"], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/data", "required_scopes": ["data.read"], "aud": "https://api.example.com"},
    {"method": "PUT", "path": "/data", "required_scopes": ["data.update"], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/data/export", "required_scopes": ["data.export"], "aud": "https://api.example.com"},
    {"method": "GET", "path": "/config", "required_scopes": ["admin.config"], "aud": "https://api.example.com"},
    {"method": "PUT", "path": "/config", "required_scopes": ["admin.config"], "aud": "https://api.example.com"}
]

#Przypasowanie polityki dot. operacji na endpointach do zakresów w tokenie
check_scopes(endpoint_access_policy, token_scopes) if {
	token_scopes_set := {scope | scope = token_scopes[_]}
    every endpoint_scope in endpoint_access_policy.required_scopes {
    	some token_scope in token_scopes_set
        token_scope = endpoint_scope
    }
}
