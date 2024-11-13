import userportalConfig from './config/userportal.config';
import admindashboardConfig from './config/admindashboard.config';
import analyticsviewerConfig from './config/analyticsviewer.config';
import salesConfig from './config/sales.config';
import claimsConfig from './config/claims.config';

const loadConfig = () => {
    const host = window.location.host;

    switch (host) {
        case 'userportal.example.com':
            return userportalConfig;
        case 'admindashboard.example.com':
            return admindashboardConfig;
        case 'analyticsviewer.example.com':
            return analyticsviewerConfig;
        case 'sales.example.org':
            return salesConfig;
        case 'claims.example.org':
            return claimsConfig;
        default:
            throw new Error('Nieznana domena');
    }
};

export default loadConfig;
