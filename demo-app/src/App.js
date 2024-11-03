import React from 'react';
import IdPConfig from './components/IdPConfig';
import TokenDisplay from './components/TokenDisplay';
import CollapsibleSection from './components/CollapsibleSection';
import UserInfo from "./components/UserInfo";
import ApiRequest from "./components/ApiRequest";

function App() {
    return (
        <div className="App">
            <h1>Tester OIDC oraz OAuth2.0</h1>
            <CollapsibleSection title="Konfiguracja IdP / Uwierzytelnianie">
                <IdPConfig />
            </CollapsibleSection>
            <CollapsibleSection title="Odpowiedź IdP / Odświeżanie / Wylogowanie">
                <TokenDisplay />
            </CollapsibleSection>
            <CollapsibleSection title="UserInfo">
                <UserInfo />
            </CollapsibleSection>
            <CollapsibleSection title="Testowanie API">
                <ApiRequest />
            </CollapsibleSection>
        </div>
    );
}

export default App;
