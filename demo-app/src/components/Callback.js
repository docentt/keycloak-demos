import React, { useEffect } from 'react';
import { useAuth } from '../authProvider';
import { useNavigate } from 'react-router-dom';

function Callback() {
    const { handleCallback } = useAuth();
    const navigate = useNavigate();

    useEffect(() => {
        const processCallback = async () => {
            try {
                await handleCallback();
                navigate('/');
            } catch (error) {
                console.error("Błąd podczas przetwarzania odpowiedzi z OP:", error);
            }
        };

        processCallback();
    }, [handleCallback, navigate]);

    return <div>Przetwarzanie odpowiedzi z OP...</div>;
}

export default Callback;