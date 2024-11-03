import React, { useState, useEffect } from 'react';
import { setPanelExpanded, isPanelExpanded } from '../utils/sessionUtils';

function CollapsibleSection({ title, children }) {
    const [isCollapsed, setIsCollapsed] = useState(isPanelExpanded(title));

    useEffect(() => {
        setPanelExpanded(title, isCollapsed);
    }, [isCollapsed, title]);

    const toggleCollapse = () => {
        setIsCollapsed(!isCollapsed);
    };

    return (
        <div className="collapsible-section">
            <div className="collapsible-header" onClick={toggleCollapse}>
                <h2>{title}</h2>
                <button className="toggle-button">
                    {isCollapsed ? "Pokaż" : "Ukryj"}
                </button>
            </div>
            {!isCollapsed && (
                <div className="collapsible-content">
                    {children}
                </div>
            )}
        </div>
    );
}

export default CollapsibleSection;