# Demonstracje Keycloak

Repozytorium pozwala na szybkie uruchomienie Keycloak z demonstracyjnymi konfiguracjami.

Wersja Keycloak: *26.0.0*

## Użycie

### Start

Uruchomienie Keycloak o parametrach:
- wersja zgodna z informacją powyżej
- przed startem skopiowanie konfiguracji z katalogu *./template-realms* do *./realms*, a następnie poprawa w niej adresacji IP,
- w trakcie startu import konfiguracji z katalogu *./realms*
- port usługi: 8080
- ścieżka usługi: */auth*
- tryb developerski
- uruchomienie w tle
- port do zdalnego debuggowania: 5005
- poświadczenia: admin / admin


    ./start_kc.sh

Dodatkowo uruchomiony zostanie testowy serwer pocztowy.

Konsola Keycloak dostępna jest pod adresem http://localhost:8080/auth
Skrzynka email typu "catch all" z testowego serwera pocztowego dostępna jest pod adresem http://localhost:5000/

### Stop

Zatrzymianie Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./stop_kc.sh

### Restart

Restart Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./restart_kc.sh

### Zrzut konfiguracji

Samo wykonanie zrzutu konfiguracji działającego Keycloak.

    ./dump_realms_kc.sh

### Podgląd logów

Podgląd logów działającego Keycloak.

    ./see_logs_kc.sh

## Konfiguracja

Testowa konfiguracja. 
Realmy: 
- test - realm z testową konfiguracją
- test2 - realm do testowania identity brokeringu (RP zintegrowany z OP, którym jest realm test)
  - konfiguracja dostawcy tożsamości http://localhost:8080/auth/admin/master/console/#/test2/identity-providers/oidc/test/settings
  - w konfiguracji należy dostosować adresy URL endpointów backchannel (zamiana z _172.18.0.2_ na adres odczytany z sieci Docker).

### Użytkownicy (realm: test)

- test / test - testowy użytkownik
  - Uprawnienia odczytu i zapisu na zasobach https://example.com/api oraz https://example.org/api
- admin / admin - testowy administrator
    - Uprawnienia administracji na zasobach https://example.com/api oraz https://example.org/api

### Użytkownicy (realm: test2)

Brak użytkowników - należy uwierzytelnić się względem realma test.

### Klienci (realm: test)

#### https://oidcdebugger.com/ 

Testowa integracja z https://oidcdebugger.com/
- client id: https://oidcdebugger.com/
- valid redirect URIs:
  - https://oidcdebugger.com/debug
- typ klienta: poufny
- uwierzytelnianie klienta:
  - metoda: client secret
  - secret: 0rsNk8Dzf9QfHHg7lnmSSrSKRrw3za5O
- role na koncie serwisowym:
  - view-users @ realm-management
- granty: 
  - Authorization Code grant, 
  - Resource Owner Password Credentials grant, 
  - Implicit grant
  - Client Credentials grant

#### Konta serwisowe

##### service-account_client_secret_jwt

Konto serwisowe z uwierzytelnianiem client_secret_jwt (patrz: https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication)

- client id: service-account_client_secret_jwt
- typ klienta: poufny
- uwierzytelnianie klienta: 
  - metoda: client_secret_jwt
  - algorytm sygnatury: HS256
  - secret: 54wgKGlaGYtaG3ZIBQWJ6mLu3v7WgW25
- granty:
    - Client Credentials grant

##### service-account_private_key_jwt

Konto serwisowe z uwierzytelnianiem private_key_jwt (patrz: https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication)

- client id: service-account_private_key_jwt
- typ klienta: poufny
- uwierzytelnianie klienta:
    - metoda: private_key_jwt
    - algorytm sygnatury: RS256
    - klucze: patrz katalog _./keys_
- granty:
    - Client Credentials grant
#### Modelowanie Serwerów Zasobów

##### https://example.com/api

Serwer Zasobów https://example.com/api
- client id: https://example.com/api
- typ klienta: bearer-only
- role:
  - read
  - write
  - admin
- granty: brak

##### https://example.org/api

Serwer Zasobów https://example.org/api
- client id: https://example.org/api
- typ klienta: bearer-only
- role:
    - read
    - write
    - admin
- granty: brak

##### https://example.com/

Aplikacja https://example.com/ (do testowania z https://oidcdebugger.com/)
- client id: https://example.com/
- valid redirect URIs:
    - https://oidcdebugger.com/debug
- typ klienta: publiczny
- role na filtrze:
  - https://example.com/api
      - read
      - write
- granty: 
  - Implicit grant

##### https://example.org/

Aplikacja https://example.org/ (do testowania z https://oidcdebugger.com/)
- client id: https://example.org/
- valid redirect URIs:
    - https://oidcdebugger.com/debug
- typ klienta: publiczny
- role na filtrze:
    - https://example.org/api
        - read
        - write
- granty:
    - Implicit grant

##### https://admin.example.com/

Aplikacja https://admin.example.com/ (do testowania z https://oidcdebugger.com/)
- client id: https://admin.example.com/
- valid redirect URIs:
    - https://oidcdebugger.com/debug
- typ klienta: publiczny
- role na filtrze:
    - https://example.com/api
        - admin
    - https://example.org/api
        - admin
- granty:
    - Implicit grant

##### http://localhost:8080/auth/realms/test2

Klient do integracji realm test2 w scenariuszu Identity Brokeringu z realm test.
- client id: http://localhost:8080/auth/realms/test2
- valid redirect URIs:
  - http://localhost:8080/auth/realms/test2/broker/test/endpoint
- valid post logout redirect URIs:
  - http://localhost:8080/auth/realms/test2/broker/test/endpoint/logout_response
- typ klienta: poufny
- uwierzytelnianie klienta:
  - metoda: private_key_jwt
  - algorytm sygnatury: RS256
  - klucze pobrane po jwks (na backchannel, dlatego po IP _172.18.0.2_ - należy zastąpić wewnętrznym IP kontenera z Keycloak): http://localhost:8080/auth/realms/test2/protocol/openid-connect/certs
- granty:
  - Authorization Code grant
- PKCE: S256

## Kolekcja Postman

W katalogu POSTMAN znajdują się pliki do zaimportowania do Postman (https://www.postman.com/) skrojone pod interakcję z demonstracyjnym Keycloak.