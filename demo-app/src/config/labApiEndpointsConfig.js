const labApiEndpointsConfig = [
    { method: "POST", path: "/policies", requiredScopes: [ ], aud: "https://api.example.org", port: 9443 },
    { method: "GET", path: "/policies/123", requiredScopes: [ ], aud: "https://api.example.org", port: 9443 },
    { method: "PUT", path: "/policies/123", requiredScopes: [ ], aud: "https://api.example.org", port: 9443 },
    { method: "POST", path: "/claims", requiredScopes: [ ], aud: "https://api.example.org", port: 9443 },
];

export default labApiEndpointsConfig;
