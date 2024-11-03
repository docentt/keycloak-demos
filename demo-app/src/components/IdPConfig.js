import React, { useState, useEffect } from 'react';
import { useAuth } from '../authProvider';
import { useConfig } from '../configContext';
import { saveOptionalScopesToSession, getOptionalScopesFromSession, setPanelExpanded, isPanelExpanded } from '../utils/sessionUtils';

function IdPConfig() {
    const config = useConfig();
    const { login, updateScopes } = useAuth();
    const [selectedScopes, setSelectedScopes] = useState(getOptionalScopesFromSession() || []);
    const [metadata, setMetadata] = useState(null);
    const [isMetadataLoading, setIsMetadataLoading] = useState(false);
    const [isMetadataVisible, setIsMetadataVisible] = useState(isPanelExpanded("metadataPanel"));

    const handleScopeChange = (scope) => {
        setSelectedScopes((prevScopes) => {
            const newScopes = prevScopes.includes(scope)
                ? prevScopes.filter((s) => s !== scope)
                : [...prevScopes, scope];
            saveOptionalScopesToSession(newScopes);
            updateScopes(newScopes);
            return newScopes;
        });
    };

    const toggleMetadataVisibility = () => {
        const newVisibility = !isMetadataVisible;
        setIsMetadataVisible(newVisibility);
        setPanelExpanded("metadataPanel", newVisibility);
        console.log("Stan panelu metadanych zapisany:", newVisibility);
    };

    useEffect(() => {
        const fetchMetadata = async () => {
            setIsMetadataLoading(true);
            try {
                const response = await fetch(`${config.authority}/.well-known/openid-configuration`);
                if (!response.ok) throw new Error("Nie udało się pobrać metadanych");
                const data = await response.json();
                setMetadata(data);
            } catch (error) {
                console.error("Błąd podczas pobierania metadanych OIDC:", error);
            } finally {
                setIsMetadataLoading(false);
            }
        };
        fetchMetadata();
    }, [config.authority]);

    return (
        <div className="config-container">
            <h2 className="config-title">Konfiguracja</h2>
            <div className="config-item">
                <span className="config-label">Client ID:</span>
                <span className="config-value">{config.clientId}</span>
            </div>
            <div className="config-item">
                <span className="config-label">OP:</span>
                <span className="config-value">{config.authority}</span>
            </div>

            <p>Domyślne zakresy:</p>
            <ul className="scopes-list">
                {config.defaultScopes.map((scope) => (
                    <li key={scope} className="scope-label">
                        {scope}
                    </li>
                ))}
            </ul>

            {config.extraScopes && config.extraScopes.length > 0 && (
                <>
                    <p>Wybierz opcjonalne zakresy:</p>
                    <div className="optional-scopes">
                        {config.extraScopes.map((scope) => (
                            <label key={scope} className="scope-option">
                                <input
                                    type="checkbox"
                                    value={scope}
                                    checked={selectedScopes.includes(scope)}
                                    onChange={() => handleScopeChange(scope)}
                                />
                                {scope}
                            </label>
                        ))}
                    </div>
                </>
            )}

            <button className="login-button" onClick={login}>
                Zaloguj się (uwierzytelnianie OIDC)
            </button>

            <div className="metadata-section">
                <button
                    className="toggle-button"
                    onClick={toggleMetadataVisibility}
                >
                    {isMetadataVisible ? "Ukryj metadane OIDC" : "Pokaż metadane OIDC"}
                </button>
                {isMetadataVisible && (
                    <div className="collapsible-content">
                        {isMetadataLoading ? (
                            <p>Ładowanie metadanych...</p>
                        ) : (
                            metadata && (
                                <div className="metadata-details">
                                    <h3>Metadane OIDC:</h3>
                                    <ul>
                                        {Object.entries(metadata).map(([key, value]) => (
                                            <li key={key}>
                                                <strong>{key}:</strong> {typeof value === "string" ? value : JSON.stringify(value, null, 2)}
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            )
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}

export default IdPConfig;
