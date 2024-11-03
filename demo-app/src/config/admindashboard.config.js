import highlightedClaimsConfig from './highlightedClaimsConfig';
import apiEndpointsConfig from './apiEndpointsConfig';

const config = {
    clientId: "https://admindashboard.example.com",
    authority: "https://login.example.com:8443/auth/realms/demo.com",
    defaultScopes: ["data.update", "admin.config"],
    extraScopes: ["openid", "email", "profile"],
    highlightedClaims: highlightedClaimsConfig,
    apiEndpoints: apiEndpointsConfig
};

export default config;
