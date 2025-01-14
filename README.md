# Keycloak Demonstrations

The repository enables quick deployment of Keycloak with demonstration configurations and integrated services (demonstration API, OIDC/OAuth2.0 Tester, LDAP, syslog).

[Polish Version of the Documentation](https://github.com/docentt/keycloak-demos/blob/main/README.pl.md)

Keycloak Version: *26.0.7*

## Requirements

To run the demonstration, you need to:

1. (Optional) Generate a TLS certificate.
2. Install the TLS certificate _./certs/keycloak-demos.crt_ in trusted root certification authorities.
3. Add domain entries used in the demonstration to the local DNS.

### Generate a Certificate

Optional step, requires OpenSSL to be installed beforehand.

**NOTE**: For security reasons, it is recommended to generate a certificate rather than using the one in _./certs/_.

```bash
cd certs/
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout keycloak-demos.key -out keycloak-demos.crt -subj "/CN=login.example.com" -addext "subjectAltName=DNS:*.example.com,DNS:*.admin.example.com,DNS:*.example.org,DNS:*.admin.example.org,DNS:*.internal.example.org,DNS:keycloak-demos"
```

### Install the TLS Certificate

Below are the steps for Windows with Chrome and Docker running on WSL. Some steps can be applied to entirely different setups.

#### Installation in OS (Windows)

1. Run _cmd_ as an administrator.
2. Execute _certmgr.msc_ from the aforementioned _cmd_.
3. Right-click on _Trusted Root Certification Authorities_ and select _All Tasks -> Import_.
4. Select the file _certs/keycloak-demos.crt_ and complete the process.

#### Installation in Docker (on WSL)

Install _ca-certificates_ (first command) only if the package has not been installed before.

```bash
sudo apt-get install -y ca-certificates
sudo cp ./certs/keycloak-demos.crt /usr/local/share/ca-certificates/keycloak-demos.crt
sudo update-ca-certificates
```

#### Installation in Browser (Chrome)

Chrome on Windows uses the system certificate store, so after adding the certificate to the system, Chrome will automatically accept it. If not, or the OS is other than Windows, perform the following steps:

1. Open Chrome.
2. In the address bar, type: _chrome://settings/security_.
3. Select _Manage Certificates_.
4. Switch to the _Trusted Root Certification Authorities_ tab.
5. Click _Import_, then _Next_, _Browse..._.
6. Select the file _certs/keycloak-demos.crt_ and complete the process.

### DNS Entries

The demonstration requires adding the following entries to the DNS on the machine running the demo (entries in _/etc/hosts_, for Windows _C:\Windows\System32\drivers\etc\hosts_):
- Keycloak
  - 127.0.0.1       login.example.com
  - 127.0.0.1       kc-admin.example.com
  - 127.0.0.1       login.example.org
- Demonstration API
  - 127.0.0.1       api.example.com
  - 127.0.0.1       api.admin.example.com
- Mail Server
  - 127.0.0.1       mail.example.com
  - 127.0.0.1       mail.example.org
- LDAP Server
  - 127.0.0.1       ldap.example.org
- Demonstration Applications (OIDC/OAuth2.0 Tester)
  - 127.0.0.1       userportal.example.com
  - 127.0.0.1       analyticsviewer.example.com
  - 127.0.0.1       admindashboard.example.com

## Usage

### Build

#### Keycloak

No build required.

#### Demonstration API

Before running the demonstration API, build the container with the runtime environment.

```bash
./build_demo-API.sh
```

#### OIDC/OAuth2.0 Tester

Before running the demonstration application (OIDC/OAuth2.0 Tester), build the container with the runtime environment.

```bash
./build_demo-app.sh
```

#### LDAP

No build required.

#### Keycloak Cluster

No build required.

### Start

#### Keycloak

Start Keycloak with the following parameters:
- Version as specified above.
- Import configuration from the *./realms* directory during startup.
- Service port: 8443.
- Service path: */auth*.
- Service domains:
  - *login.example.com*
  - *login.example.org* (for selected realm).
  - *kc-admin.example.com* (for administration).
- Management port: 9000.
- Management path: */*.
- Debug mode for hostnames.
- Metrics: enabled.
- Health checks: enabled.
- Developer mode.
- Background execution.
- Remote debugging port: 5005.
- Credentials: admin/admin.

Command:

```bash
./start_kc.sh
```

Additionally, a test mail server and a syslog server will be started.

Keycloak console is available at https://login.example.com:8443/.
Test mail server "catch-all" inbox is accessible at http://mail.example.com:5000/ / http://mail.example.org:5000/.

#### Demonstration API

Start the demonstration API with the following parameters:
- Service port: 9443.
- Service path: */*.
- Service domains:
  - *api.example.com*.
  - *api.admin.example.com*.

Command:

```bash
./start_demo-API.sh
```

The demonstration API is available at:
- https://api.example.com:9443/.
- https://api.admin.example.com:9443/.

#### OIDC/OAuth2.0 Tester

Start the demonstration application (OIDC/OAuth2.0 Tester) with the following parameters:
- Service port: 443.
- Service domains:
  - *userportal.example.com*.
  - *analyticsviewer.example.com*.
  - *admindashboard.example.com*.

Command:

```bash
./start_demo-app.sh
```

The demonstration application (OIDC/OAuth2.0 Tester) is available at:
- https://userportal.example.com/.
- https://analyticsviewer.example.com/.
- https://admindashboard.example.com/.

OIDC/OAuth2.0 Tester communicates with Keycloak and the demonstration API.

#### LDAP

Start the OpenLDAP server with the following parameters:
- Based on the [bitnami/openldap](https://hub.docker.com/r/bitnami/openldap) image.
- Import _./LDAP/keycloak-demos.ldif_ during startup.
- Logging level 1 (more information: [OpenLDAP loglevel](https://www.openldap.org/doc/admin26/slapdconfig.html#loglevel%20%3Clevel%3E)).
- No TLS configuration.
- Service port: 389.
- Background execution.
- Bind credentials: _cn=admin,dc=example,dc=org / admin_.

Command:

```bash
./start_ldap.sh
```

The OpenLDAP server is available:
- For Keycloak at _ldap://ldap-keycloak-demos:389_.
- Externally at _ldap://ldap.example.org:389_.

#### Keycloak Cluster

Start the Keycloak cluster with additional services. Keycloak cluster parameters:
- Infinispan configuration in _/clustered/cache-ispn.xml_
- Version as specified above.
- Number of Keycloak nodes: 3.
- Service port: 443.
- Service path: */auth*.
- Service domain:
  - *login.example.com*.
- Management ports (for individual Keycloak nodes): 9001-9003.
- Management path: */*.
- Metrics: enabled (including cache metrics histograms).
- Health checks: enabled.
- Background execution.
- Credentials: admin/admin.

Command:

```bash
./start_clustered_kc.bash
```

Additional services:
- PostgreSQL database version 15 (data stored in _./clustered/postgresql/data/_).
- HAProxy:
  - Configuration in _./config/clustered/haproxy/haproxy.cfg_.
  - Logging to syslog.
  - Session affinity:
    - Cookie _KC_NODE_ binds users to specific backend nodes.
  - Load balancing:
    - Method: round robin.
  - Health monitoring of the backend:
    - Using the _/health/live_ endpoint of Keycloak on the management port (9000).
  - TLS termination.
  - Rewriting X-Forwarded-* headers (Proto, Port, For, Host).
  - Dynamic DNS resolution with Docker.
  - Statistics panel:
    - Available on port 8080.
    - Credentials: admin/admin.
- Syslog server.

Keycloak console is available at https://login.example.com/.
Cluster console is available at http://localhost:8080/.

### Stop

#### Keycloak

Stop Keycloak and dump the configuration.

```bash
./stop_kc.sh [options]
```

##### Script Options

| Option            | Description                                |
|-------------------|--------------------------------------------|
| `--no-dump`       | Does not dump the configuration.           |

#### Demonstration API

Stop the demonstration API.

```bash
./stop_demo-API.sh
```

#### OIDC/OAuth2.0 Tester

Stop the demonstration application (OIDC/OAuth2.0 Tester).

```bash
./stop_demo-app.sh
```

#### LDAP

Stop the OpenLDAP server.

```bash
./stop_ldap.sh
```

#### Keycloak Cluster

Stop the Keycloak cluster along with additional services.

```bash
./stop_clustered_kc.bash
```

### Restart

#### Keycloak

Restart Keycloak and dump the configuration.

```bash
./restart_kc.sh [options]
```

##### Script Options

| Option            | Description               |
|-------------------|---------------------------|
| `--no-dump`       | Does not dump configuration.|
| `--smtp-restart`  | Restarts the SMTP server. |

### Log Monitoring

#### Keycloak

Monitor logs of the running Keycloak instance.

```bash
./see_logs_kc.sh
```

#### Demonstration API

Monitor logs of the running demonstration API.

```bash
./see_logs_demo-API.sh
```

or

```bash
./see_logs_demo-API-opa.sh
```

depending on the container logs to view.

#### LDAP

Monitor logs of the running OpenLDAP server.

```bash
./see_logs_ldap.sh
```

Monitor the number of connections maintained by LDAP.

```bash
./monitor_ldap.sh
```

#### Syslog

Monitor logs of the running syslog server.

```bash
./see_logs_syslog.sh
```

#### Keycloak Cluster Node

Monitor logs of a running Keycloak cluster node.

```bash
./see_logs_clustered_kc.sh [node_number]
```

##### Arguments

| Argument        | Description                     |
|-----------------|---------------------------------|
| `[node_number]` | Node number to manage (1-3).    |

### CLI Configuration Management

#### keycloak-config-cli

Script to run the [keycloak-client-cli](https://github.com/adorsys/keycloak-config-cli) tool from Docker.
Managed realms:
- keycloak-client-cli-demo-manual
- keycloak-client-cli-demo

Configuration is in the _config/keycloak-config-cli_ directory.

```bash
./keycloak-config-cli-demo.sh
```

#### terraform-provider-keycloak

Script to run the [terraform-provider-keycloak](https://github.com/keycloak/terraform-provider-keycloak) tool from Docker.
Managed realm:
- terraform-provider-keycloak-demo

Configuration is in the _config/terraform-provider-keycloak_ directory.

```bash
./terraform-provider-keycloak-demo.sh
```

### Managing Keycloak Cluster Nodes

Manage Keycloak cluster nodes, including starting, stopping, and restarting specific nodes.

```bash
./manage_nodes.sh [action] [node_number]
```

#### Actions

| Action    | Description                              |
|-----------|------------------------------------------|
| `start`   | Starts the specified Keycloak node.      |
| `stop`    | Stops the specified Keycloak node.       |
| `restart` | Restarts the specified Keycloak node.    |

#### Arguments

| Argument        | Description                     |
|-----------------|---------------------------------|
| `[node_number]` | Node number to manage (1-3).    |

## Configuration

Test configuration.
Realms:
- demo.com - Realm with test configuration.
- demo.org - Realm for testing identity brokering (RP integrated with OP, which is the demo.com realm) and LDAP user federation.
  - Identity provider configuration: https://login.example.com:8443/auth/admin/master/console/#/demo.org/identity-providers/oidc/login.example.com/settings.
  - LDAP user federation configuration: https://login.example.com:8443/auth/admin/master/console/#/demo.org/user-federation/ldap/4bee9eb3-c5ad-44fe-b9e7-11ccef192e52.

### Users (realm: demo.com)

- user/user - Regular user.
- premium/premium - Premium user.
- analyst/analyst - Data analyst.
- admin/admin - Administrator.

For testing account linking with LDAP-federated users in the _demo.org_ realm (LDAP synchronization mode configuration required):
- anowak/anowak
- awojcik/awojcik
- jkowalski/jkowalski
- pwisniewski/pwisniewski
- tmazur/tmazur

### Users (realm: demo.org)

No local users. Authentication is possible against the _demo.com_ realm. Additionally, after starting the OpenLDAP server, users are federated via LDAP:
- anowak/anowak
- awojcik/awojcik
- jkowalski/jkowalski
- pwisniewski/pwisniewski
- tmazur/tmazur

### Clients (realm: demo.com)

#### https://oidcdebugger.com/

Test integration with https://oidcdebugger.com/:
- client id: https://oidcdebugger.com/.
- valid redirect URIs:
  - https://oidcdebugger.com/debug.
- Client type: Confidential.
- Client authentication:
  - Method: Client secret.
  - Secret: 0rsNk8Dzf9QfHHg7lnmSSrSKRrw3za5O.
- Service account roles:
  - view-users @ realm-management.
- Grants:
  - Authorization Code grant.
  - Resource Owner Password Credentials grant.
  - Implicit grant.
  - Client Credentials grant.

#### Service Accounts

##### service-account_client_secret_jwt

Service account with client_secret_jwt authentication (see: https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication).

- client id: service-account_client_secret_jwt.
- Client type: Confidential.
- Client authentication:
  - Method: client_secret_jwt.
  - Signature algorithm: HS256.
  - Secret: 54wgKGlaGYtaG3ZIBQWJ6mLu3v7WgW25.
- Grants:
  - Client Credentials grant.

##### service-account_private_key_jwt

Service account with private_key_jwt authentication (see: https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication).

- client id: service-account_private_key_jwt.
- Client type: Confidential.
- Client authentication:
  - Method: private_key_jwt.
  - Signature algorithm: RS256.
  - Keys: see the _./keys_ directory.
- Grants:
  - Client Credentials grant.

#### Resource Server Modeling

##### https://api.example.com

Resource server https://api.example.com:
- client id: https://api.example.com.
- Client type: Bearer-only.
- Grants: None.

##### https://api.admin.example.com

Resource server https://api.admin.example.com:
- client id: https://api.admin.example.com.
- Client type: Bearer-only.
- Grants: None.

##### https://userportal.example.com

Application https://userportal.example.com (for testing with https://oidcdebugger.com/, Postman, and OIDC/OAuth2.0 Tester):
- client id: https://userportal.example.com.
- Valid redirect URIs:
  - https://oidcdebugger.com/debug.
  - https://oauth.pstmn.io/v1/callback.
  - https://userportal.example.com/callback.
- Valid post logout redirect URIs:
  - https://userportal.example.com.
- Client type: Public.
- Scopes:
  - profile.read.
  - profile.update (optional).
- aud:
  - https://api.example.com.
- Grants:
  - Authorization Code grant.
  - Resource Owner Password Credentials grant.
  - Implicit grant.

##### https://analyticsviewer.example.com

Application https://analyticsviewer.example.com (for testing with https://oidcdebugger.com/, Postman, and OIDC/OAuth2.0 Tester):
- client id: https://analyticsviewer.example.com.
- Valid redirect URIs:
  - https://oidcdebugger.com/debug.
  - https://oauth.pstmn.io/v1/callback.
  - https://analyticsviewer.example.com/callback.
- Valid post logout redirect URIs:
  - https://analyticsviewer.example.com.
- Client type: Public.
- Scopes:
  - data.read.
  - data.export.
- aud:
  - https://api.example.com.
- Grants:
  - Authorization Code grant.
  - Resource Owner Password Credentials grant.
  - Implicit grant.

##### https://admindashboard.example.com

Application https://admindashboard.example.com (for testing with https://oidcdebugger.com/, Postman, and OIDC/OAuth2.0 Tester):
- client id: https://admindashboard.example.com.
- Valid redirect URIs:
  - https://oidcdebugger.com/debug.
  - https://oauth.pstmn.io/v1/callback.
  - https://admindashboard.example.com/callback.
- Valid post logout redirect URIs:
  - https://admindashboard.example.com.
- Client type: Public.
- Scopes:
  - data.update.
  - admin.config.
- aud:
  - https://api.example.com.
  - https://api.admin.example.com.
- Grants:
  - Authorization Code grant.
  - Resource Owner Password Credentials grant.
  - Implicit grant.

#### https://login.example.org:8443/auth/realms/demo.org

Client for integrating the demo.org realm in the Identity Brokering scenario with the demo.com realm.
- client id: https://login.example.org:8443/auth/realms/demo.org.
- Valid redirect URIs:
  - https://login.example.org:8443/auth/realms/demo.org/broker/login.example.com/endpoint.
- Valid post logout redirect URIs:
  - https://login.example.org:8443/auth/realms/demo.org/broker/login.example.com/endpoint/logout_response.
- Client type: Confidential.
- Client authentication:
  - Method: private_key_jwt.
  - Signature algorithm: RS256.
  - Keys obtained via JWKS (backchannel).
- Grants:
  - Authorization Code grant.
- PKCE: S256.

#### opa

Client for online token validation within OPA policies.

- client id: opa.
- Client type: Confidential.
- Client authentication:
  - Method: private_key_jwt.
  - Signature algorithm: RS256.
  - Keys: see the _./keys_ directory.

## Postman Collection

The _POSTMAN_ directory contains files for importing into Postman (https://www.postman.com/) tailored for interacting with the demonstration Keycloak setup.