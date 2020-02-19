# PCF/TAS  mysql-exposer
expose PCF / TAS hosted mysql database instances externally using tcp-routed service gateway (haproxy)

EXPERIMENTAL

Use a haproxy binary, PCF hosted binary-buildpack staged app and PCF's TCP-Router to expose MySQL database service-instances for consumption directly from outside the platform service network.

How it works
Deploy instance of mysql-exposer as an app to PCF, bind it to your mysql db service instanace and expose it using tcp-route support in PCF.
The mysql-exposer expects to be bound to a p.mysql service instance.
On startup a pre-launch script extracts the mysql SI hostname and port and updates the haproxy.conf file 
haproxy is then launched.
Exposing this app using tcp-router will function to relay traffic to the bound database host/port



1. Create a p.mysql DB instance in PCF

2. Modify manifest of mysql-exposer to provide unique name for instance

3. Push mysql-exposer without a route / without starting

	cf push --no-route --no-start

4. Bind mysql db instance to mysql-exposer app (assumes mysqlexposerxxx is chosen name for pushed instance in manifest.yml)

	cf bind-service mysqlexposerxxx mysqldbname

4. Create TCP-ingress Route using PCF's TCP route support (chose a known free port or have tcp router select port for you)

	cf create-route DemoSpace tcp.<apps-domain> --port 63305

5. Map mysql-exposer instance to this route 

	cf map-route mysqlexposerxxx tcp.<apps domain> --port 63305

6. Start the gateway

	cf start mysqlexposerxxx

7. Create a service key and retrieve the database connection details 

	cf create-service-key mysqldb mykey

	cf service-key mysqldb mykey

Provide the following details as your external DB connection string
Hostname: tcp.<pcf apps domain>
Port: < exposed port chosen / selected during tcp-route creation
Username: from service key
Password: from service key
