package config

#Mapowanie Issuer -> OIDC Metadata URL
metadata_urls := {
    "https://login.example.com:8443/auth/realms/demo.com": concat("", ["https://keycloak-demos:8443/auth/realms/demo.com", "/.well-known/openid-configuration"]),
    "https://login.example.org:8443/auth/realms/demo.org": concat("", ["https://keycloak-demos:8443/auth/realms/demo.org", "/.well-known/openid-configuration"])
}

#Mapowanie Issuer -> klient do online introspection
introspection_clients := {
    "https://login.example.com:8443/auth/realms/demo.com": {
        "client_id": "opa",
        "client_secret": jwk_private_key,
        "authentication_method": "private_key_jwt"
    },
    "https://login.example.org:8443/auth/realms/demo.org": {
        "client_id": "",
        "client_secret": "",
        "authentication_method": ""
    }
}

tls_ca_cert_file := "/keycloak-demos.crt"

#Klucz RSA do podpisywania assercji do autoryzacji klientów do introspekcji tokenów
jwk_private_key := {
    "kty":"RSA",
    "n":"vBsLlYD0ql9zyCKaIQDsx3NIxtqY6jA-0L15f8Z4jwzpf1JtkaSV1lz9QFVvahCspuujGds3dqG1Ik_dBvx4f2ssDJjY902EUiSftJwcvoTzw-m-UW2CubKRIhc1svi7xOHwRtJeLcm4M2sg2NsZg5rao1XdsmYVSKzVLIvxoLTfNN7nKrlaaRHLjETyMMqy_SdGJZuYpLD6Sdi1RRFk2J8WmFUWJZ3gbomjwmUhtehQAOYMX6lzeGL1RIHqr75EUzmfbsKYdqeMlLnt9fvvKBQ4L7FjROveMNCCoN0abBRbS5Y5dVUzcSxJZjGfh83kMuzLeMwGJ4Xk5PCGftaVmw",
    "e":"AQAB",
    "d":"gQ0E-4LHWIO4CVxD5dSenY9oJJUgR7rlvYvgaVsepvWy1BkW9s61xaVyUcrLbzcVXEdZVInjGU6D2JB2ES7w9GnwhIvwfmn-F-TsdJqN1d-c5ZHdcjvxbbkmfP7zZl_jYoWntM7qsfsslooutNhMPs_kpB5qxNPoUj3Q2okAMsH2_CtlAjgAipGtDDEZ5aI4OLzXQp3nCTHaoST_7QUSdTYNBh1NxjlEwWPYv9B9MlEOZN-QiyFkW7_1hjkGspJ0DkHdhnGaRUtn-L2RzoCmgE6Z32dLktrzlYN5e3Ollu2wwEFeA6W6isTfAgom5ZMgPvgNAqPZfWFHJhxcw47eYQ",
    "p":"43WDOvqzAGuilgxmz2BExaVlQauiBioRKUOQjJGwE1sO78g4UV6RdEO_S083KC1wyLbSzfMro_BOppZ906_Pdeoli-7HGEenPMYqzle-soBc7WE39I4VGqtnoRKIdzPc7KhNixxj_cgtlY7wkjbCzIgCrl62pdxDckHPI2BgoVk",
    "q":"07VqLGaE5TKW60QMhC8YRHCE-Dz0YaqYJHRMLxyYD3zPAjlrzyd1q66qFY_yz7ybvIDHy1a97LMWc8pMk6YAAlJQwsXfMAXKxbvf_mC-ozdILzQWu3y29M2ZiKNPp8VydHIZ4Jge9oxhuoI3xBX3JIvWLKoeJMmwfhivbbWv_BM",
    "dp":"cL7d9o0vzySLKb8p8t7wF9wc7clKfa26Ze7EprjMQzvekoJ3T_YFOVEfcA_q8jJb9lGQ-l7vocpK4g40fopl1jfitpL8Aw_5WImNzEv4DXjNFykaWFFZKqgNrOyH0jZV6sSd8zd2ZOQlnD2HB6K3OjSsx4vREzO0Bt2R9CIgo7k",
    "dq":"Uwe4b1d50YYoyHZ0zjbGNrlGfTEyy0cjylBOPL_jJ1fUvFOW47TfIokrLa-6FB0tmx2KvkXz0Oxf5uO1asbVBBQSloESSnxLDYfkjpiUy-B3kAPG0ptUCejEyWD7cZovjFnfqkUfB6UBAyvlASN4PT4Wroe9sMHlVV8LFmUGcz8",
    "qi":"KrNv1rFTiowU0asimjaYbyWcn1_3aqUNeL7s4vLT_SECb2rn70LSXiEd_Eanqk5TJNuO_NToDTVcf_ak2B28tJaohi_RfE3CwrvEcJ26aKr6bM1wVtG2pOd3Kdg7Ln92acLJDob0_MhoB_tjPfVDCyU8Dz9gC6Yc8xrKORbytHU"
}
