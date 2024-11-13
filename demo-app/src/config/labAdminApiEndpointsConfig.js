const labAdminApiEndpointsConfig = [
    { method: "GET", path: "/claims", requiredScopes: [ ], aud: "https://api.admin.example.org", port: 9443 },
    { method: "POST", path: "/claims/123/approve", requiredScopes: [ ], aud: "https://api.admin.example.org", port: 9443 },
    { method: "POST", path: "/claims/123/reject", requiredScopes: [ ], aud: "https://api.admin.example.org", port: 9443 },
    { method: "POST", path: "/claims/123/process", requiredScopes: [ ], aud: "https://api.internal.example.org", port: 9443 },
];

export default labAdminApiEndpointsConfig;
