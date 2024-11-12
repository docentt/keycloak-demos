const apiEndpointsConfig = [
    { method: "GET", path: "/public", requiredScopes: [], aud: "https://api.example.com", port: 9443 },
    { method: "GET", path: "/profile", requiredScopes: ["profile.read"], aud: "https://api.example.com", port: 9443 },
    { method: "PUT", path: "/profile", requiredScopes: ["profile.update"], aud: "https://api.example.com", port: 9443 },
    { method: "GET", path: "/data/123", requiredScopes: ["data.read"], aud: "https://api.example.com", port: 9443 },
    { method: "PUT", path: "/data/123", requiredScopes: ["data.update"], aud: "https://api.example.com", port: 9443 },
    { method: "GET", path: "/data/export", requiredScopes: ["data.export"], aud: "https://api.example.com", port: 9443 },
    { method: "GET", path: "/config", requiredScopes: ["admin.config"], aud: "https://api.admin.example.com", port: 9443 },
    { method: "PUT", path: "/config", requiredScopes: ["admin.config"], aud: "https://api.admin.example.com", port: 9443 },
];

export default apiEndpointsConfig;
