# Demonstracje Keycloak

Repozytorium pozwala na szybkie uruchomienie Keycloak z demonstracyjnymi konfiguracjami.

Wersja Keycloak: *24.0.5*

## Start

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

## Stop

Zatrzymianie Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./stop_kc_24.sh

## Restart

Restart Keycloak wraz z wykonaniem zrzutu konfiguracji.

    ./restart_kc_24.sh

## Zrzut konfiguracji

Samo wykonanie zrzutu konfiguracji działającego Keycloak.

    ./dump_realms_kc_24.sh

## Podgląd logów

Podgląd logów działającego Keycloak.

    ./see_logs_kc_24.sh
