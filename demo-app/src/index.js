import React from 'react';
import ReactDOM from 'react-dom';
import Root from './Root';
import { AuthProvider } from './authProvider';
import { ConfigProvider } from './configContext';
import loadConfig from './configLoader';
import './styles.css';

let config;
let configError = null;

try {
    config = loadConfig();
} catch (error) {
    console.error("Błąd ładowania konfiguracji:", error.message);
    configError = error.message;
}

ReactDOM.render(
    configError ? (
        <div style={{ color: 'red', textAlign: 'center', marginTop: '20px' }}>
            <h1>Błąd ładowania konfiguracji</h1>
            <p>Nieznana domena lub problem z konfiguracją: {configError}</p>
        </div>
    ) : (
        <React.StrictMode>
            <ConfigProvider config={config}>
                <AuthProvider>
                    <Root />
                </AuthProvider>
            </ConfigProvider>
        </React.StrictMode>
    ),
    document.getElementById('root')
);