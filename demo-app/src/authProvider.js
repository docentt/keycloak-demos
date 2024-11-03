import { UserManager } from 'oidc-client';
import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { useConfig } from './configContext';
import { getOptionalScopesFromSession } from './utils/sessionUtils';
import axios from 'axios';

const AuthContext = createContext();

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
    const config = useConfig();
    const [userManager, setUserManager] = useState(null);
    const [tokens, setTokens] = useState(null);
    const [metadata, setMetadata] = useState(null);
    const [selectedScopes, setSelectedScopes] = useState(getOptionalScopesFromSession() || []);

    const updateScopes = useCallback((scopes) => {
        setSelectedScopes(scopes);
    }, []);

    useEffect(() => {
        const fetchMetadata = async () => {
            try {
                const response = await axios.get(`${config.authority}/.well-known/openid-configuration`);
                setMetadata(response.data);
            } catch (error) {
                console.error("Błąd podczas pobierania metadanych OIDC:", error);
            }
        };
        fetchMetadata();
    }, [config.authority]);

    useEffect(() => {
        const allScopes = [...config.defaultScopes, ...selectedScopes];
        const manager = new UserManager({
            authority: config.authority,
            client_id: config.clientId,
            redirect_uri: `${window.location.origin}/callback`,
            response_type: 'code',
            scope: allScopes.join(' '),
            post_logout_redirect_uri: window.location.origin,
        });

        setUserManager(manager);
    }, [config, selectedScopes]);

    const login = useCallback(async () => {
        if (userManager) {
            try {
                await userManager.signinRedirect();
            } catch (error) {
                console.error("Błąd podczas logowania:", error);
            }
        }
    }, [userManager]);

    const handleCallback = useCallback(async () => {
        if (userManager) {
            try {
                const user = await userManager.signinRedirectCallback();
                const tokensData = {
                    access_token: user.access_token,
                    id_token: user.id_token,
                    refresh_token: user.refresh_token,
                    token_type: user.token_type,
                    scope: user.scope,
                    expires_at: user.expires_at,
                    profile: user.profile
                };
                setTokens(tokensData);
                console.log("Zalogowano:", user);
            } catch (error) {
                console.error("Błąd podczas przetwarzania callbacka:", error);
            }
        }
    }, [userManager]);

    const logout = useCallback(async () => {
        if (userManager && tokens?.id_token) {
            try {
                await userManager.signoutRedirect();
                setTokens(null);  // Clear tokens on logout
            } catch (error) {
                console.error("Błąd podczas wylogowywania:", error);
            }
        }
    }, [userManager, tokens]);

    const refreshAccessToken = async (refreshToken) => {
        if (!metadata?.token_endpoint) return;
        try {
            const params = new URLSearchParams();
            params.append('grant_type', 'refresh_token');
            params.append('refresh_token', refreshToken);
            params.append('client_id', config.clientId);

            const response = await axios.post(metadata.token_endpoint, params, {
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
            });

            const { access_token, id_token, refresh_token, token_type, expires_in } = response.data;
            const refreshedTokens = {
                ...tokens,
                access_token,
                id_token,
                refresh_token,
                token_type,
                expires_at: Date.now() + expires_in * 1000,
            };
            setTokens(refreshedTokens);
            return refreshedTokens;
        } catch (error) {
            console.error("Błąd podczas odświeżania tokena:", error);
            throw error;
        }
    };

    return (
        <AuthContext.Provider value={{ login, handleCallback, logout, tokens, refreshAccessToken, updateScopes }}>
            {children}
        </AuthContext.Provider>
    );
};
