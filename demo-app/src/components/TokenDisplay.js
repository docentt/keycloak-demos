import React, { useState } from 'react';
import { useAuth } from '../authProvider';
import CollapsibleToken from './CollapsibleToken';
import { useConfig } from '../configContext';
import { formatTimestamp, isTimestamp } from '../utils/timestampUtils';

function TokenDisplay() {
    const { tokens, refreshAccessToken, logout } = useAuth();
    const config = useConfig();
    const [refreshing, setRefreshing] = useState(false);

    const refreshToken = async () => {
        if (!tokens?.refresh_token) return;

        setRefreshing(true);
        try {
            const response = await refreshAccessToken(tokens.refresh_token);
            if (response?.access_token) {
                alert('Token został odświeżony.');
            }
        } catch (error) {
            console.error("Błąd podczas odświeżania tokena:", error);
        } finally {
            setRefreshing(false);
        }
    };

    return (
        <div className="token-display">
            <h2>Wyświetlanie tokenów</h2>
            {tokens ? (
                <div className="token-sections">
                    <div className="additional-token-info">
                        <h3>Pozostałe elementy odpowiedzi:</h3>
                        <ul>
                            {Object.entries(tokens).map(([key, value]) => (
                                !["access_token", "id_token", "refresh_token"].includes(key) && (
                                    <li key={key}>
                                        <strong>{key}:</strong>{" "}
                                        {isTimestamp(key, value) ? (
                                            <span>{value} {formatTimestamp(value)} (CET/CEST)</span>
                                        ) : typeof value === 'object' ? (
                                            <pre>{JSON.stringify(value, null, 2)}</pre>
                                        ) : (
                                            value
                                        )}
                                    </li>
                                )
                            ))}
                        </ul>
                    </div>
                    {tokens.access_token && (
                        <CollapsibleToken
                            tokenName="Access Token"
                            tokenValue={tokens.access_token}
                            highlightedClaims={config.highlightedClaims.access_token || []}
                        />
                    )}
                    {tokens.id_token && (
                        <CollapsibleToken
                            tokenName="ID Token"
                            tokenValue={tokens.id_token}
                            highlightedClaims={config.highlightedClaims.id_token || []}
                        />
                    )}
                    {tokens.refresh_token && (
                        <CollapsibleToken
                            tokenName="Refresh Token"
                            tokenValue={tokens.refresh_token}
                            highlightedClaims={config.highlightedClaims.refresh_token || []}
                        />
                    )}

                    <div className="refresh-section">
                        <button
                            onClick={refreshToken}
                            disabled={refreshing}
                            className="refresh-button"
                        >
                            {refreshing ? 'Odświeżanie...' : 'Odśwież token'}
                        </button>
                        {tokens.id_token && (
                            <button
                                onClick={logout}
                                className="logout-button"
                            >
                                Wyloguj się
                            </button>
                        )}
                    </div>
                </div>
            ) : (
                <p>Brak tokenów do wyświetlenia.</p>
            )}
        </div>
    );
}

export default TokenDisplay;
