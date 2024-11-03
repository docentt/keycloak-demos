const CONFIG_KEY = "appConfig";

export const getConfigFromSession = () => {
    const config = sessionStorage.getItem(CONFIG_KEY);
    return config ? JSON.parse(config) : { expandedPanels: {} };
};

export const saveConfigToSession = (config) => {
    sessionStorage.setItem(CONFIG_KEY, JSON.stringify(config));
};

export const setPanelExpanded = (panelName, isExpanded) => {
    const config = getConfigFromSession();
    config.expandedPanels[panelName] = isExpanded;
    saveConfigToSession(config);
};

export const isPanelExpanded = (panelName) => {
    const config = getConfigFromSession();
    return config.expandedPanels[panelName] || false;
};

export const saveOptionalScopesToSession = (scopes) => {
    const config = getConfigFromSession();
    config.optionalScopes = scopes;
    saveConfigToSession(config);
};

export const getOptionalScopesFromSession = () => {
    const config = getConfigFromSession();
    return config.optionalScopes || [];
};
