import labHighlightedClaimsConfig from './labHighlightedClaimsConfig';
import labApiEndpointsConfig from './labApiEndpointsConfig';

const config = {
    clientId: "https://sales.example.org",
    authority: "https://login.example.com:8443/auth/realms/lab.com",
    defaultScopes: ["openid", "email", "profile", "roles"],
    extraScopes: [ ],
    highlightedClaims: labHighlightedClaimsConfig,
    apiEndpoints: labApiEndpointsConfig
};

export default config;
