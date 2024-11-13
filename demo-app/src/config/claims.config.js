import labHighlightedClaimsConfig from './labHighlightedClaimsConfig';
import labAdminApiEndpointsConfig from './labAdminApiEndpointsConfig';

const config = {
    clientId: "https://claims.example.org",
    authority: "https://login.example.com:8443/auth/realms/lab.com",
    defaultScopes: ["openid", "email", "profile", "roles"],
    extraScopes: [ ],
    highlightedClaims: labHighlightedClaimsConfig,
    apiEndpoints: labAdminApiEndpointsConfig
};

export default config;
