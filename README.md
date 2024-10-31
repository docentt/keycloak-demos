# Demonstracje Keycloak

Repozytorium pozwala na szybkie uruchomienie Keycloak z demonstracyjnymi konfiguracjami oraz zintegrowanymi usługami (demonstracyjne API, LDAP).

Wersja Keycloak: *26.0.0*

## Wymagania

Aby móc uruchomić demonstrację, należy:

1. (opcjonalnie) Wygenerować certyfikat TLS.
2. Zainstalować certyfikat TLS _./certs/keycloak-demos.crt_ w zaufanych głównych urzędach certyfikacji.
3. Dodać wpisy z domenami wykorzystywanymi w demonstracji do lokalnego DNS.

### Wygenerowanie certyfikatu

Krok opcjonalny, wymaga wcześniejszej instalacji OpenSSL.

**UWAGA**: Ze względów bezpieczeństwa zalecane jest wygenerowanie certyfikatu, zamiast wykorzystywania certyfikatu znajdującego się w _./certs/_.

    cd certs/
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout keycloak-demos.key -out keycloak-demos.crt -subj "/CN=login.example.com" -addext "subjectAltName=DNS:login.example.com,DNS:login.example.org,DNS:keycloak-demos"

### Instalacja certyfikatu TLS 

Poniżej podano kroki dla systemu Windows z przeglądarką Chrome oraz Docker uruchomionym w WSL, aczkolwiek część z tych kroków można zastosować w zupełnie innych setupach.

#### Instalacja w OS (Windows)

1. uruchomić _cmd_ jako administrator,
2. uruchomić _certmgr.msc_ z poziomu ww. _cmd_,
3. na pozycji _Zaufane główne urzędy certyfikacji_ wcisnąć prawy przycisk i wybrać _Wszystkie zadania -> import_,
4. wybrać plik _certs/keycloak-demos.crt_ i dokończyć proces.

#### Instalacja w Docker (instalacja na WSL)

Doinstalowanie _ca-certificates_ (pierwsza komenda) jedynie jeżeli pakiet nie był wcześniej zainstalowany.

    sudo apt-get install -y ca-certificates
    sudo cp ./certs/keycloak-demos.crt /usr/local/share/ca-certificates/keycloak-demos.crt
    sudo update-ca-certificates

#### Instalacja w przeglądarce (Chrome)

Chrome na Windows korzysta z systemowego magazynu certyfikatów, więc po dodaniu certyfikatu do systemu, Chrome automatycznie go zaakceptuje.
Jeżeli jednak tak się nie stanie, lub OS jest inny niż Windows, należy wykonać poniższe czynności.

1. uruchomić przeglądarkę Chrome,
2. w pasku adresu wpisać: _chrome://settings/security_,
3. wybrać opcję _Zarządzaj certyfikatami_,
4. przełączyć na zakładkę _Zaufane główne urzędy certyfikacji_,
5. kliknąć przycisk _Import_, a następnie _Dalej_, _Przeglądaj..._,
6. wybrać plik _certs/keycloak-demos.crt_ i dokończyć proces.

### Wpisy DNS 

Demonstracja wymaga dodania następujących wpisów do DNS na komputerze na którym uruchamiane jest demo (wpisy w _/etc/hosts_, w przypadku Windows w _C:\Windows\System32\drivers\etc\hosts_):
- Keycloak
  - 127.0.0.1       login.example.com
  - 127.0.0.1       login.example.org
- demonstracyjne API
  - 127.0.0.1       api.example.com
  - 127.0.0.1       api.example.org

## Użycie

### Build

#### Keycloak

Usługa nie wymaga budowania.

#### Demonstracyjne API

Przed uruchomieniem demonstracyjnego API, należy zbudować kontener ze środowiskiem pozwalającym na jego uruchomienie.

    ./build_demo-API.sh

#### LDAP

Usługa nie wymaga budowania.

### Start

#### Keycloak

Uruchomienie Keycloak o parametrach:
- wersja zgodna z informacją powyżej
- w trakcie startu import konfiguracji z katalogu *./realms*
- port usługi: 8443
- ścieżka usługi: */auth*
- domeny usługi: 
  - *login.example.com*
  - *login.example.org* (dla wybranego realm)
- tryb developerski
- uruchomienie w tle
- port do zdalnego debuggowania: 5005
- poświadczenia: admin / admin



    ./start_kc.sh

Dodatkowo uruchomiony zostanie testowy serwer pocztowy.

Konsola Keycloak dostępna jest pod adresem https://login.example.com:8443/auth
Skrzynka email typu "catch all" z testowego serwera pocztowego dostępna jest pod adresem http://localhost:5000/

#### Demonstracyjne API

Uruchomienie demonstracyjnego API o parametrach:
- port usługi: 9443
- ścieżka usługi: */*
- domeny usługi:
  - *api.example.com*
  - *api.example.org*



    ./start_demo-API.sh

Demonstracyjne API dostępne jest pod adresami:
- https://api.example.com:9443/
- https://api.example.org:9443/

API odpowiada decyzjami autoryzacyjnymi realizowanymi przez agenta [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) uruchomionego w osobnym kontenerze.
Do OPA kierowane są jedynie żądania zawierające nagłówek HTTP _Authorization_ z tokenem na okaziciela.

#### LDAP

Uruchomienie serwera OpenLDAP o parametrach:
- na bazie obrazu [bitnami/openldap](https://hub.docker.com/r/bitnami/openldap)
- w trakcie startu import _./LDAP/keycloak-demos.ldif_
- logowanie na poziomie 1 (więcej informacji: [OpenLDAP loglevel](https://www.openldap.org/doc/admin26/slapdconfig.html#loglevel%20%3Clevel%3E))
- brak konfiguracji TLS
- port usługi: 389
- uruchomienie w tle
- bind: _cn=admin,dc=example,dc=org / admin_



    ./start_ldap.sh

Serwer OpenLDAP dostępny:
- dla Keycloak pod adresem _ldap://ldap-keycloak-demos:389_
- zewnętrznie pod adresem _ldap://localhost:389_

### Stop

#### Keycloak

Zatrzymianie Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./stop_kc.sh [opcje]

##### Opcje uruchomienia skryptu

| Opcja            | Opis                                                   |
|------------------|--------------------------------------------------------|
| `--no-dump`      | Nie wykonuje zrzutu konfiguracji.                      |

#### Demonstracyjne API

Zatrzymianie demonstracyjnego API.

    ./stop_demo-API.sh

#### LDAP

Zatrzymianie serwera OpenLDAP.

    ./stop_ldap.sh

### Restart

#### Keycloak

Restart Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./restart_kc.sh [opcje]

##### Opcje uruchomienia skryptu
| Opcja            | Opis                              |
|------------------|-----------------------------------|
| `--no-dump`      | Nie wykonuje zrzutu konfiguracji. |
| `--smtp-restart` | Zrestartuje serwer pocztowy.      |

### Podgląd logów

#### Keycloak

Podgląd logów działającego Keycloak.

    ./see_logs_kc.sh

#### Demonstracyjne API

Podgląd logów działającego demonstracyjnego API.

    ./see_logs_demo-API.sh

lub

    ./see_logs_demo-API-opa.sh

w zależności od tego, logi którego z kontenerów chcemy podejrzeć.

#### LDAP

Podgląd logów działającego serwera OpenLDAP.

    ./see_logs_ldap.sh

## Konfiguracja

Testowa konfiguracja. 
Realmy: 
- demo.com - realm z testową konfiguracją
- demo.org - realm do testowania identity brokeringu (RP zintegrowany z OP, którym jest realm demo.com) oraz federacji użytkowników przez LDAP
  - konfiguracja dostawcy tożsamości https://login.example.com:8443/auth/admin/master/console/#/demo.org/identity-providers/oidc/login.example.com/settings
  - konfiguracja federacji użytkowników przez LDAP https://login.example.com:8443/auth/admin/master/console/#/demo.org/user-federation/ldap/4bee9eb3-c5ad-44fe-b9e7-11ccef192e52

### Użytkownicy (realm: demo.com)

- user / user - zwykły użytkownik
- premium / premium - użytkownik premium
- analyst / analyst - analityk danych
- admin / admin - administrator

Do testowania account linkingu z użytkownikami federowanymi przez LDAP w realm _demo.org_ (wymagana zmiana konfiguracji trybu synchronizacji LDAP):
- anowak / anowak
- awojcik / awojcik
- jkowalski / jkowalski
- pwisniewski / pwisniewski
- tmazur / tmazur

### Użytkownicy (realm: demo.org)

Brak użytkowników lokalnych, można uwierzytelnić się względem realma _demo.com_, dodatkowo po uruchomieniu serwera OpenLDAP użytkownicy federowani przez LDAP:
- anowak / anowak
- awojcik / awojcik
- jkowalski / jkowalski
- pwisniewski / pwisniewski
- tmazur / tmazur

### Klienci (realm: demo.com)

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

##### https://api.example.com

Serwer Zasobów https://api.example.com
- client id: https://api.example.com
- typ klienta: bearer-only
- granty: brak

##### https://api.example.org

Serwer Zasobów https://api.example.org
- client id: https://api.example.org
- typ klienta: bearer-only
- granty: brak

##### https://userportal.example.com/

Aplikacja https://userportal.example.com/ (do testowania z https://oidcdebugger.com/ lub Postman)
- client id: https://userportal.example.com/
- valid redirect URIs:
  - https://oidcdebugger.com/debug
  - https://oauth.pstmn.io/v1/callback
- typ klienta: publiczny
- zakresy:
  - profile.read
  - profile.update (opcjonalny)
- aud:
  - https://api.example.com
- granty: 
  - Authorization Code grant,
  - Resource Owner Password Credentials grant,
  - Implicit grant

##### https://analyticsviewer.example.com/

Aplikacja https://analyticsviewer.example.com/ (do testowania z https://oidcdebugger.com/ lub Postman)
- client id: https://analyticsviewer.example.com/
- valid redirect URIs:
  - https://oidcdebugger.com/debug
  - https://oauth.pstmn.io/v1/callback
- typ klienta: publiczny
- zakresy:
  - data.read
  - data.export
- aud:
  - https://api.example.com
- granty:
  - Authorization Code grant,
  - Resource Owner Password Credentials grant,
  - Implicit grant

##### https://admindashboard.example.com/

Aplikacja https://admindashboard.example.com/ (do testowania z https://oidcdebugger.com/ lub Postman)
- client id: https://admindashboard.example.com/
- valid redirect URIs:
  - https://oidcdebugger.com/debug
  - https://oauth.pstmn.io/v1/callback
- typ klienta: publiczny
- zakresy:
  - data.update
  - admin.config
- aud:
  - https://api.example.com
  - https://api.example.org
- granty:
  - Authorization Code grant,
  - Resource Owner Password Credentials grant,
  - Implicit grant

#### https://login.example.org:8443/auth/realms/demo.org

Klient do integracji realm demo.org w scenariuszu Identity Brokeringu z realm demo.com.
- client id: https://login.example.org:8443/auth/realms/demo.org
- valid redirect URIs:
  - https://login.example.org:8443/auth/realms/demo.org/broker/login.example.com/endpoint
- valid post logout redirect URIs:
  - https://login.example.org:8443/auth/realms/demo.org/broker/login.example.com/endpoint/logout_response
- typ klienta: poufny
- uwierzytelnianie klienta:
  - metoda: private_key_jwt
  - algorytm sygnatury: RS256
  - klucze pobrane po jwks (na backchannel)
- granty:
  - Authorization Code grant
- PKCE: S256

#### opa

Klient do weryfikacji tokenów online z poziomu polityk OPA.

- client id: opa
- typ klienta: poufny
- uwierzytelnianie klienta:
  - metoda: private_key_jwt
  - algorytm sygnatury: RS256
  - klucze: patrz katalog _./keys_

## Kolekcja Postman

W katalogu POSTMAN znajdują się pliki do zaimportowania do Postman (https://www.postman.com/) skrojone pod interakcję z demonstracyjnym Keycloak.