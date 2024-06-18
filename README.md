# Demonstracje Keycloak

Repozytorium pozwala na szybkie uruchomienie Keycloak z demonstracyjnymi konfiguracjami.

Wersja Keycloak: *24.0.5*

## Użycie

### Start

Uruchomienie Keycloak o parametrach:
- wersja zgodna z informacją powyżej
- w trakcie startu import konfiguracji z katalogu *./realms*
- port usługi: 8080
- ścieżka usługi: */auth*
- tryb developerski
- uruchomienie w tle
- port do zdalnego debuggowania: 5005
- poświadczenia: admin / admin


    ./start_kc_24.sh

Konsola Keycloak dostępna jest pod adresem http://localhost:8080/auth

### Stop

Zatrzymianie Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./stop_kc_24.sh

### Restart

Restart Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./restart_kc_24.sh

### Zrzut konfiguracji

Samo wykonanie zrzutu konfiguracji działającego Keycloak.

    ./dump_realms_kc_24.sh

### Podgląd logów

Podgląd logów działającego Keycloak.

    ./see_logs_kc_24.sh

## Konfiguracja

Testowa konfiguracja. 
Realm: test

### Użytkownicy

test / test - testowy użytkownik

### Klienci

#### https://oidcdebugger.com/ 

Testowa integracja z https://oidcdebugger.com/
- client id: https://oidcdebugger.com/
- typ klienta: publiczny
- granty: 
  - Authorization Code grant, 
  - Resource Owner Password Credentials grant, 
  - Implicit grant

#### service-account_client_secret_jwt

Konto serwisowe z uwierzytelnianiem client_secret_jwt (patrz: https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication)

- client id: service-account_client_secret_jwt
- typ klienta: poufny
- uwierzytelnianie klienta: 
  - metoda: client_secret_jwt
  - algorytm sygnatury: HS256
  - secret: 54wgKGlaGYtaG3ZIBQWJ6mLu3v7WgW25
- granty:
    - Client Credentials grant

#### service-account_private_key_jwt

Konto serwisowe z uwierzytelnianiem private_key_jwt (patrz: https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication)

- client id: service-account_private_key_jwt
- typ klienta: poufny
- uwierzytelnianie klienta:
    - metoda: private_key_jwt
    - algorytm sygnatury: RS256
    - klucze: patrz katalog _./keys_
- granty:
    - Client Credentials grant

## Kolekcja Postman

W katalogu POSTMAN znajdują się pliki do zaimportowania do Postman (https://www.postman.com/) skrojone pod interakcję z demonstracyjnym Keycloak.