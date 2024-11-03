import userportalConfig from './config/userportal.config';
import admindashboardConfig from './config/admindashboard.config';
import analyticsviewerConfig from './config/analyticsviewer.config';

const loadConfig = () => {
    const host = window.location.host;

    switch (host) {
        case 'userportal.example.com':
            return userportalConfig;
        case 'admindashboard.example.com':
            return admindashboardConfig;
        case 'analyticsviewer.example.com':
            return analyticsviewerConfig;
        default:
            throw new Error('Nieznana domena');
    }
};

export default loadConfig;
