package auth

import rego.v1

import data.config.metadata_urls
import data.config.introspection_clients
import data.config.tls_ca_cert_file
import data.scopes.endpoint_access
import data.scopes.check_scopes

default allow := false
default global_roles := []
default client_roles := []
default all_client_roles := {}
default endpoint_requirements_or_empty := {}

default selected_claims_email := ""

endpoint_requirements := _endpoint_requirements if{
    some _endpoint_requirements in endpoint_access
    _endpoint_requirements.method == input.method
    _endpoint_requirements.path == input.path
    _endpoint_requirements.aud == expected_audience
}

endpoint_requirements_or_empty := endpoint_requirements

errors["incorrect_endpoint_or_method"] if {
	not endpoint_requirements
}

# OIDC Discovery

unverified_token_issuer := io.jwt.decode(input.access_token)[1].iss
metadata_url := metadata_urls[unverified_token_issuer]
introspection_client_id := introspection_clients[unverified_token_issuer].client_id
expected_audience := concat("://", [input.scheme, input.host])

metadata := http.send({
    "url": metadata_url,
    "method": "GET",
    "force_cache": true,
    "force_cache_duration_seconds": 86400,
    "tls_ca_cert_file": tls_ca_cert_file
}).body

# Weryfikacja tokenu offline

decoded_jwt := _decoded_jwt if {
    not input.want_online_introspection
    jwks_response := http.send({
	    "url": metadata.jwks_uri,
	    "method": "GET",
	    "force_cache": true,
	    "force_cache_duration_seconds": 3600,
        "tls_ca_cert_file": tls_ca_cert_file
    })

    _decoded_jwt := io.jwt.decode_verify(input.access_token, {
    	"cert": jwks_response.raw_body,
    	"iss": metadata.issuer,
    	"aud": expected_audience
    })
}

offline_valid_jwt := decoded_jwt[0]
offline_header := decoded_jwt[1]
offline_payload := decoded_jwt[2]

offline_matched_aud := aud if {
	some aud
	aud = offline_payload.aud[_]
	aud == expected_audience
}

offline_matched_aud := expected_audience if {
	offline_payload.aud == expected_audience
}

offline_matched_roles := offline_payload.resource_access[offline_matched_aud].roles

offline_scopes := split(offline_payload.scope, " ")

offline_scopes_valid if{
    check_scopes(endpoint_requirements, offline_scopes)
}

allow if {
	offline_valid_jwt
	offline_matched_aud
	offline_scopes_valid
}

errors["JWT_invalid_or_expired"] if {
    not input.want_online_introspection
	not offline_valid_jwt
}

errors["incorrect_audience"] if {
	offline_valid_jwt
	not offline_matched_aud
}

errors["insufficient_token_scope"] if {
	offline_valid_jwt
	not offline_scopes_valid
}

config := {
    "iss": metadata.issuer,
    "jwks_url": metadata.jwks_uri
} if {
    not input.want_online_introspection
}

global_roles := offline_payload.realm_access.roles
client_roles := offline_matched_roles
all_client_roles := offline_payload.resource_access
selected_claims_email = offline_payload["email"]

token_data := {
    "matched_aud": offline_matched_aud,
    "matched_roles": client_roles,
    "global_roles": global_roles,
    "scopes": offline_scopes,
    "all_auds": offline_payload.aud,
    "all_roles": all_client_roles,
    "selected_claims": {
        "email": selected_claims_email
    }
} if {
	offline_valid_jwt
}

# Weryfikacja tokenu online

# uwierzytelnianie client_secret_basic

token_introspection_response := _token_introspection_response if {
    input.want_online_introspection
    "client_secret_basic" == introspection_clients[unverified_token_issuer].authentication_method
    _token_introspection_response := http.send({
        "method": "POST",
        "url": metadata.introspection_endpoint,
        "headers": {
            "Authorization": concat(" ", ["Basic", base64.encode(
                sprintf("%s:%s", [introspection_client_id, introspection_clients[unverified_token_issuer].client_secret])
                )]),
            "Content-Type": "application/x-www-form-urlencoded"
        },
        "raw_body": concat("", [
            "token=", input.access_token
        ]),
        "tls_ca_cert_file": tls_ca_cert_file,
#	    "force_cache": true,
#	    "force_cache_duration_seconds": 5
    })
}

# uwierzytelnianie client_secret_post

token_introspection_response := _token_introspection_response if {
    input.want_online_introspection
    "client_secret_post" == introspection_clients[unverified_token_issuer].authentication_method
    _token_introspection_response := http.send({
        "method": "POST",
        "url": metadata.introspection_endpoint,
        "headers": {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        "raw_body": concat("", [
            "token=", input.access_token,
            "&client_id=", introspection_client_id,
            "&client_secret=", introspection_clients[unverified_token_issuer].client_secret

        ]),
        "tls_ca_cert_file": tls_ca_cert_file,
#	    "force_cache": true,
#	    "force_cache_duration_seconds": 5
    })
}

# uwierzytelnianie private_key_jwt / RS256 - generowanie assercji

client_assertion := io.jwt.encode_sign(
    {
        "alg": "RS256",
        "typ": "JWT"
    },{
        "sub": introspection_client_id,
        "iss": introspection_client_id,
        "aud": metadata.issuer,
        "iat": floor(time.now_ns() / 1000000000),
        "exp": floor(time.now_ns() / 1000000000) + 60,
        "jti": base64url.encode(crypto.sha256(sprintf("%d", [time.now_ns()])))
      },
    introspection_clients[unverified_token_issuer].client_secret
) if {
    input.want_online_introspection
    "private_key_jwt" == introspection_clients[unverified_token_issuer].authentication_method
}

# uwierzytelnianie client_secret_jwt / HS256 - generowanie assercji

client_assertion := io.jwt.encode_sign(
    {
        "alg": "HS256",
        "typ": "JWT"
    },{
        "sub": introspection_client_id,
        "iss": introspection_client_id,
        "aud": concat( "", [metadata.issuer, "/protocol/openid-connect/token"]),
        "iat": floor(time.now_ns() / 1000000000),
        "exp": floor(time.now_ns() / 1000000000) + 60,
        "jti": base64url.encode(crypto.sha256(sprintf("%d", [time.now_ns()])))
      },
    introspection_clients[unverified_token_issuer].client_secret
) if {
    input.want_online_introspection
    "client_secret_jwt" == introspection_clients[unverified_token_issuer].authentication_method
}

# uwierzytelnianie  private_key_jwt / RS256 lub client_secret_jwt / HS256

token_introspection_response := _token_introspection_response if {
    client_assertion
    _token_introspection_response := http.send({
        "method": "POST",
        "url": metadata.introspection_endpoint,
        "headers": {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        "raw_body": concat("", [
            "token=", input.access_token,
            "&client_id=", introspection_client_id,
            "&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
            "&client_assertion=", client_assertion
        ]),
        "tls_ca_cert_file": tls_ca_cert_file,
#	    "force_cache": true,
#	    "force_cache_duration_seconds": 5,
    })
}

token_introspection_result := token_introspection_response.body if {
    token_introspection_response.status_code == 200
}

online_is_active := token_introspection_result.active

online_matched_aud := aud if {
	some aud
	aud = token_introspection_result.aud[_]
	aud == expected_audience
}

online_matched_aud := expected_audience if {
	token_introspection_result.aud == expected_audience
}

online_matched_roles := token_introspection_result.resource_access[online_matched_aud].roles

online_scopes := split(token_introspection_result.scope, " ")

online_scopes_valid if {
    check_scopes(endpoint_requirements, online_scopes)
}

allow if {
	online_is_active
	online_matched_aud
	online_scopes_valid
}

errors["JWT_invalid_or_expired"] if {
    input.want_online_introspection
	not online_is_active
}

errors["incorrect_audience"] if {
	online_is_active
	not online_matched_aud
}

errors["insufficient_token_scope"] if {
	online_is_active
	not online_scopes_valid
}

config := {
    "iss": metadata.issuer,
    "introspection_endpoint": metadata.introspection_endpoint
} if {
    input.want_online_introspection
}

global_roles := token_introspection_result.realm_access.roles
client_roles := online_matched_roles
all_client_roles := token_introspection_result.resource_access
selected_claims_email = token_introspection_result["email"]

token_data := {
    "matched_aud": online_matched_aud,
    "matched_roles": client_roles,
    "global_roles": global_roles,
    "scopes": online_scopes,
    "all_auds": token_introspection_result.aud,
    "all_roles": all_client_roles,
    "selected_claims": {
        "email": selected_claims_email
    }
} if {
	online_is_active
}

# Rezultat

# Sukces

policy_evaluation := {
    "allow": allow,
    "online_introspected": input.want_online_introspection,
    "token_data": token_data,
    "endpoint_requirements": endpoint_requirements_or_empty,
    "config": config
} if {
    allow
}

# Odmowa

default code := 403

code := 401 if {
    not decoded_jwt[0]
    not input.want_online_introspection
}

code := 401 if {
    not online_is_active
    input.want_online_introspection
}

policy_evaluation := {
    "allow": allow,
    "online_introspected": input.want_online_introspection,
    "code": code,
    "reasons": errors,
    "endpoint_requirements": endpoint_requirements_or_empty,
    "config": config
} if {
    not allow
}