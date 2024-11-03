import highlightedClaimsConfig from './highlightedClaimsConfig';
import apiEndpointsConfig from './apiEndpointsConfig';

const config = {
    clientId: "https://userportal.example.com",
    authority: "https://login.example.com:8443/auth/realms/demo.com",
    defaultScopes: ["profile.read"],
    extraScopes: ["profile.update", "openid", "email", "profile"],
    highlightedClaims: highlightedClaimsConfig,
    apiEndpoints: apiEndpointsConfig
};

export default config;
