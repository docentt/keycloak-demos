# Szablony konfiguracji

Katalog zawiera szablony konfiguracji. Szablony te mają ustawioną sieć _172.18.0.0/16_.

W trakcie uruchamiania demonstracji, do Docker dodawana jest (przez skrypt _../configure.sh_) sieć o nazwie _keycloak-demos_.

Ww. skrypt przekopiuje szablony konfiguracji do katalogu **../realms**, a następnie dokona podmiany adresów IP na zgodnie z aktualną adresacją sieci _keycloak-demos_ we **wszystkich** plikach znajdujących się w docelowym katalogu.