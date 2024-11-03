import React, { useState, useEffect } from 'react';
import { setPanelExpanded, isPanelExpanded } from '../utils/sessionUtils';
import { formatTimestamp, isTimestamp } from '../utils/timestampUtils';

function CollapsibleToken({ tokenName, tokenValue, highlightedClaims = [] }) {
    const [isCollapsed, setIsCollapsed] = useState(isPanelExpanded(tokenName));

    useEffect(() => {
        setPanelExpanded(tokenName, isCollapsed);
    }, [isCollapsed, tokenName]);

    const getShortToken = (token) => {
        if (token && token.length > 20) {
            return `${token.slice(0, 10)}...${token.slice(-10)}`;
        }
        return token;
    };

    const toggleCollapse = () => {
        setIsCollapsed(!isCollapsed);
    };

    const copyToClipboard = (e) => {
        e.stopPropagation();
        navigator.clipboard.writeText(tokenValue);
        alert(`${tokenName} skopiowany do schowka!`);
    };

    const decodeToken = (token) => {
        try {
            const [header, payload, signature] = token.split('.');
            const decodedHeader = JSON.parse(atob(header));
            const decodedPayload = JSON.parse(atob(payload));
            return { decodedHeader, decodedPayload, signature };
        } catch (error) {
            console.error("Błąd dekodowania tokena:", error);
            return null;
        }
    };

    const decodedToken = !isCollapsed && decodeToken(tokenValue);

    const renderClaims = (claims) => {
        return Object.entries(claims).map(([key, value]) => (
            <div key={key} className={`claim-item ${highlightedClaims.includes(key) ? 'highlighted-claim' : ''}`}>
                <strong>{key}:</strong> {typeof value === 'object' ? JSON.stringify(value, null, 2) : value}
                {isTimestamp(key, value) && (
                    <span className="timestamp">
                        <em>({formatTimestamp(value)} CET/CEST)</em>
                    </span>
                )}
            </div>
        ));
    };

    return (
        <div className="collapsible-token">
            <div className="token-header" onClick={toggleCollapse}>
                <h3>{tokenName}</h3>
                <button className="toggle-button">
                    {isCollapsed ? "Pokaż" : "Ukryj"}
                </button>
                <button onClick={copyToClipboard} className="copy-button">
                    Kopiuj token
                </button>
            </div>
            <pre className="token-value">
                {isCollapsed
                    ? getShortToken(tokenValue)
                    : decodedToken ? (
                        <>
                            <div className="token-section">
                                <strong>Header:</strong>
                                {renderClaims(decodedToken.decodedHeader)}
                            </div>
                            <div className="token-section">
                                <strong>Payload:</strong>
                                {renderClaims(decodedToken.decodedPayload)}
                            </div>
                            <div className="signature-section">
                                <strong>Signature:</strong> {decodedToken.signature}
                            </div>
                        </>
                    ) : "Nieprawidłowy token"}
            </pre>
        </div>
    );
}

export default CollapsibleToken;
