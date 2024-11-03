import React, { createContext, useContext } from 'react';

const ConfigContext = createContext(null);

export const useConfig = () => {
    const context = useContext(ConfigContext);
    if (!context) {
        throw new Error("useConfig musi być użyty w obrębie ConfigProvider");
    }
    return context;
};

export const ConfigProvider = ({ config, children }) => {
    return (
        <ConfigContext.Provider value={config}>
            {children}
        </ConfigContext.Provider>
    );
};
