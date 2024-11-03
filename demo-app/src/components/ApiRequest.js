import React, { useState } from 'react';
import { useAuth } from '../authProvider';
import { useConfig } from '../configContext';
import axios from 'axios';
import ApiResponse from './ApiResponse';

function ApiRequest() {
    const { tokens } = useAuth();
    const config = useConfig();
    const [response, setResponse] = useState(null);
    const [error, setError] = useState(null);
    const [wantOnlineIntrospection, setWantOnlineIntrospection] = useState(false);

    const hasRequiredScopes = (requiredScopes) => {
        if (!tokens?.access_token) return false;
        const tokenScopes = tokens.scope?.split(' ') || [];
        return requiredScopes.every(scope => tokenScopes.includes(scope));
    };

    const hasRequiredAudience = (aud) => {
        try {
            const decodedToken = JSON.parse(atob(tokens.access_token.split('.')[1]));
            if (Array.isArray(decodedToken.aud)) {
                return decodedToken.aud.includes(aud);
            }
            return decodedToken.aud === aud;
        } catch (error) {
            console.error("Błąd dekodowania access tokena:", error);
            return false;
        }
    };

    const groupedEndpoints = config.apiEndpoints.reduce((acc, endpoint) => {
        if (hasRequiredScopes(endpoint.requiredScopes) && hasRequiredAudience(endpoint.aud)) {
            acc.available.push(endpoint);
        } else {
            acc.unavailable.push(endpoint);
        }
        return acc;
    }, { available: [], unavailable: [] });

    const sendRequest = async (method, aud, port, path) => {
        setError(null);
        setResponse(null);

        try {
            const apiUrl = `${aud}:${port}${path}`;
            const headers = tokens?.access_token ? {
                Authorization: `Bearer ${tokens.access_token}`,
            } : {};

            const result = await axios({
                method,
                url: apiUrl,
                headers,
                params: wantOnlineIntrospection ? { want_online_introspection: true } : {},
            });

            setResponse({ ...result.data, status_code: result.status });
        } catch (err) {
            if (err.response) {
                setResponse({ ...err.response.data, status_code: err.response.status });
            } else {
                setError({
                    status: 'Nieznany',
                    message: err.message,
                });
            }
        }
    };

    return (
        <div className="api-request">
            <h2>Wysyłanie żądań do API</h2>

            <div className="introspection-toggle">
                <label>
                    <input
                        type="checkbox"
                        checked={wantOnlineIntrospection}
                        onChange={() => setWantOnlineIntrospection(!wantOnlineIntrospection)}
                    />
                    Wymuś online introspection
                </label>
            </div>

            <div className="endpoint-list">
                <h3>Dostępne Endpointy:</h3>
                {groupedEndpoints.available.map(endpoint => (
                    <div key={`${endpoint.method}-${endpoint.path}`} className="endpoint-item available">
                        <strong>{endpoint.method}</strong> {endpoint.aud}:{endpoint.port}{endpoint.path}
                        <button
                            onClick={() => sendRequest(endpoint.method, endpoint.aud, endpoint.port, endpoint.path)}
                        >
                            Wyślij żądanie
                        </button>
                    </div>
                ))}

                <h3>Niedostępne Endpointy:</h3>
                {groupedEndpoints.unavailable.map(endpoint => (
                    <div key={`${endpoint.method}-${endpoint.path}`} className="endpoint-item unavailable">
                        <strong>{endpoint.method}</strong> {endpoint.aud}:{endpoint.port}{endpoint.path}
                        <button
                            onClick={() => sendRequest(endpoint.method, endpoint.aud, endpoint.port, endpoint.path)}
                        >
                            Wyślij żądanie
                        </button>
                    </div>
                ))}
            </div>

            {response && <ApiResponse response={response} />}
            {error && (
                <div className="error-section">
                    <p>Błąd: {error.status} - {error.message}</p>
                </div>
            )}
        </div>
    );
}

export default ApiRequest;
