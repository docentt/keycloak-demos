import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import App from './App';
import Callback from './components/Callback';

function Root() {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<App />} />
                <Route path="/callback" element={<Callback />} />
            </Routes>
        </Router>
    );
}

export default Root;
