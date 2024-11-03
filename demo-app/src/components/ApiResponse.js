import React from 'react';
import ReactJson from 'react-json-view';

function ApiResponse({ response, error }) {
    if (!response && !error) return null;

    const isAllowed = response?.status === 'ALLOW';
    const statusMessage = isAllowed ? 'Dozwolono' : 'Odmowa';
    const httpStatus = response?.status_code || error?.status || 'Nieznany';

    return (
        <div className="api-response">
            <div className={`status-message ${isAllowed ? 'status-allowed' : 'status-denied'}`}>
                Status odpowiedzi z API: {statusMessage}
            </div>
            <p className="status-http">Status HTTP: {httpStatus}</p>

            <div className="json-viewer">
                <ReactJson
                    src={response || error}
                    name={false}
                    theme="monokai"
                    iconStyle="triangle"
                    collapsed={false}
                    enableClipboard={false}
                    displayDataTypes={false}
                    displayObjectSize={false}
                />
            </div>
        </div>
    );
}

export default ApiResponse;
