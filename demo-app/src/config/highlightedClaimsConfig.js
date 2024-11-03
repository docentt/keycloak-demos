const highlightedClaimsConfig = {
    access_token: ["alg", "aud", "azp", "exp", "iss", "typ", "scope"],
    id_token: ["alg", "aud", "azp", "iss", "typ", "at_hash"],
    refresh_token: ["alg", "aud", "azp", "exp", "iss", "typ", "scope"],
};

export default highlightedClaimsConfig;
