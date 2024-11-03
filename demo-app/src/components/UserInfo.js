import React, { useState, useEffect } from 'react';
import { useAuth } from '../authProvider';
import CollapsibleSection from './CollapsibleSection';
import { useConfig } from '../configContext';

function UserInfo() {
    const { tokens } = useAuth();
    const config = useConfig();
    const [userInfo, setUserInfo] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [userInfoEndpoint, setUserInfoEndpoint] = useState(null);

    useEffect(() => {
        const fetchMetadata = async () => {
            setLoading(true);
            try {
                const metadataResponse = await fetch(`${config.authority}/.well-known/openid-configuration`);
                if (!metadataResponse.ok) throw new Error("Nie udało się pobrać metadanych OIDC");

                const metadata = await metadataResponse.json();
                setUserInfoEndpoint(metadata.userinfo_endpoint);
            } catch (err) {
                setError("Błąd podczas pobierania metadanych: " + err.message);
            } finally {
                setLoading(false);
            }
        };

        if (config.authority) {
            fetchMetadata();
        } else {
            setError("Brak zdefiniowanego authority w konfiguracji.");
        }
    }, [config.authority]);

    useEffect(() => {
        if (!userInfoEndpoint || !tokens?.access_token) return;

        const fetchUserInfo = async () => {
            setLoading(true);
            setError(null);

            try {
                const response = await fetch(userInfoEndpoint, {
                    method: 'GET',
                    headers: {
                        'Authorization': `Bearer ${tokens.access_token}`
                    }
                });

                if (!response.ok) throw new Error('Błąd podczas pobierania informacji o użytkowniku');

                const data = await response.json();
                setUserInfo(data);
            } catch (err) {
                setError("Błąd podczas pobierania informacji o użytkowniku: " + err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchUserInfo();
    }, [userInfoEndpoint, tokens]);

    return (
        <CollapsibleSection title="Informacje o użytkowniku">
            {loading ? (
                <p>Ładowanie...</p>
            ) : error ? (
                <p className="error">Błąd: {error}</p>
            ) : userInfo ? (
                <div className="userinfo-display">
                    <pre>{JSON.stringify(userInfo, null, 2)}</pre>
                </div>
            ) : (
                <p>Brak dostępnych informacji o użytkowniku.</p>
            )}
        </CollapsibleSection>
    );
}

export default UserInfo;
