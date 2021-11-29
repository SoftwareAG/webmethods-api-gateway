# **Securing Elasticsearch for API Gateway 10.11**
- [Overview of the tutorial](#Overview-of-the-tutorial)
- [Required knowledge](#Required-knowledge)
- [Why?](#why)
- [Prerequisite steps](#Prerequisite-steps)
- [Securing InternalDataStore Using ReadonlyREST](#Securing-InternalDataStore-Using-ReadonlyREST) 
  - [Step 1: Download ReadonlyREST plugin compatible with Elasticsearch 7.13.0](#step-1-download-readonlyrest-plugin-compatible-with-elasticsearch-7130)
  - [Step 2: Installation and Initialization of ReadonlyREST plugin](#step-2-installation-and-initialization-of-readonlyrest-plugin)
  - [Step 3: Protect InternalDataStore with two way SSL and Basic Authorization](#step-3-protect-internaldatastore-with-two-way-ssl-and-basic-authorization)
  - [Step 4: Secure the internode communication](#step-4-secure-the-internode-communication)
  - [Step 5: Changing Kibana configurations to connect to Elasticsearch](#step-5-changing-kibana-configurations-to-connect-to-elasticsearch)
  - [Step 6: Changing API Gateway configurations to connect to Elasticsearch](#step-6-changing-api-gateway-configurations-to-connect-to-elasticsearch)
  - [Step 7: Configuring ReadonlyREST with user generated certificates (optional)](#step-7-configuring-readonlyrest-with-user-generated-certificates-optional)
- [Securing InternalDataStore Using Search Guard](#securing-internaldatastore-using-search-guard) 
  - [Step 1: Download Search Guard plugin compatible with Elasticsearch 7.13.0](#step-1-download-search-guard-plugin-compatible-with-elasticsearch-7130)
  - [Step 2: Installation and Initialization of Search Guard plugin](#step-2-installation-and-initialization-of-search-guard-plugin)
  - [Step 3: Protect InternalDataStore with Basic Authorization](#step-3-protect-internaldatastore-with-basic-authorization)
  - [Step 4: Changing Kibana configurations to connect to Elasticsearch](#step-4-changing-kibana-configurations-to-connect-to-elasticsearch)
  - [Step 5: Changing API Gateway configurations to connect to Elasticsearch](#step-5-changing-api-gateway-configurations-to-connect-to-elasticsearch)
  - [Step 6: Configuring Search Guard with user generated certificates (optional)](#step-6-configuring-search-guardwith-user-generated-certificates-optional)
- [Troubleshooting : Search Guard Plugin](#troubleshooting--search-guard-plugin)
- [References](#References)
- [Downloadable artifacts](#Downloadable-artifacts)
# **Overview of the tutorial**
This tutorial helps to understand how the ***InternalDataStore** of APIGateway 10.11* can be secured using **Search Guard** or ***ReadonlyREST*** , the Elasticsearch plugins that offers encryption, authentication and authorization. In this context, these plugins helps to secure the InternalDataStore by exposing it over HTTPS protocol and enabling a basic authentication by configuring users and securing inter node communication in the clustered environment .

This tutorial covers the below steps in detail for each of the plugins **Search Guard** and **ReadonlyREST**.

- Installation and initialization of the plugin.
- Protect InternalDataStore with SSL and Basic Authorization.
- Changing Kibana configurations to securely connect to Elasticsearch.
- Configuring API Gateway to securely connect to Elasticsearch.
- Configuring the plugins with user generated certificates.
# **Required knowledge**
The reader has to have,

- a basic understanding of API Gateway and its communication with InternalDataStore for storing data.
- a basic understanding of Kibana and its communication with InternalDataStore for rendering the dashboards in API Gateway.
# **Why?**
This document is intended for customers who want to protect their InternalDataStore , a wrapper over Elasticsearch, with Authentication and SSL using the external plugins that are compatible for the Elasticsearch version 7.13.0 on  APIGateway  version 10.11.
# **Prerequisite steps**
Complete the below prerequisites steps before get into the details of securing ***InternalDataStore*** of API Gateway using  ***Search Guard*** or ***ReadonlyREST*** plugin.

- Install API Gateway advanced edition of version 10.11.
# **Securing InternalDataStore Using *ReadonlyREST***
The below sections describe the details of securing InternalDataStore using ***ReadonlyREST*** plugin by installing the plugin and adding the necessary configurations in InternalDataStore, Kibana and API Gateway.
## **Step 1: Download ReadonlyREST plugin compatible with Elasticsearch 7.13.0**
This section explains how to download the ReadonlyREST plugin of the Elasticsearch 7.13.0 version used by the InternalDataStore.

You can download the ReadonlyREST plugin compatible for Elasticsearch 7.13.0 from [https://readonlyrest.com/download](https://readonlyrest.com/download/) .

![](attachments/image1.png)

You will get an email notification after submitting the request (click GET IT NOW button) to the given email Id with a link to download the ReadonlyREST plugin. You can download it to the desired location in the file system.
## **Step 2: Installation and Initialization of ReadonlyREST plugin**
This section explains how to install the ReadonlyREST plugin which is downloaded before.

- Stop the API Gateway server.
- Open the command prompt to the location <***SAG\_Root>/InternalDataStore/bin***.
- Issue the command ***elasticsearch-plugin.bat install file:///<**plugin file location in the file system**>*** and give 'y' when the installation procedure prompts for additional required permissions it requires 
  and confirm the installation is completed with the message displayed as **"Installed readonlyrest"**.

  **E.x :**

  ![](attachments/image2.png)

- After successful installation, go to the location  <***SAG\_Root>/InternalDataStore/config***  and create an empty file named ***readonlyrest.yml*** (in the same directory where elasticsearch.yml is found).
- Copy the folder ***sagconfig*** from ***<SAG\_Root>/IntegrationServer/instances/<Instance\_Name>/packages/WmAPIGateway/config/resources/elasticsearch/*** to ***<SAG\_Root>/InternalDataStore***.
- Now copy the sample keystore and trustore files (which will be used later in below steps) ***node-0-keystore.jks*** and ***truststore.jks*** from ***<SAG\_Root>/InternalDataStore/sagconfig***  to ***<SAG\_Root>/InternalDataStore/config*** because the keystore should be stored in the same directory with  elasticsearch.yml and readonlyrest.yml.
## **Step 3: Protect InternalDataStore with two way SSL and Basic Authorization**
**Option 1 ) : Plain text credentials :**

Open <***SAG\_Root>/InternalDataStore/config/readonlyrest.yml*** and add below contents.
```
Note : Make sure the contents are indented properly as shown so that the YAML parser can parse them correctly.  
```

```
 readonlyrest:    
     access_control_rules:
  
     - name: "Require HTTP Basic Auth"
       type: allow
       auth_key: Administrator:manage
            
     ssl:
       enable: true
       keystore_file: "node-0-keystore.jks"
       keystore_pass: a362fbcce236eb098973
       key_pass: a362fbcce236eb098973
       client_authentication: true

```

Details :

- access control rule name "Require HTTP Basic Auth"  indicates its Basic auth authentication.
- ***auth\_key***  has the credentials (username/password) in the plain text.
- ssl block is for SSL configuration.  
  - Property '**client\_authentication**' denotes the **2 way SSL Authentication**. By default, this is disabled.
  - If you don't want the server/InternalDataStore to validate client authentication, you can remove this property or set the value to **false**.
- Now open <***SAG\_Root>/InternalDataStore/config/elasticsearch.yml*** and add the below configuration statement and save the file.

  This will be used for HTTPS connection for Elasticsearch.
  ```
  http.type: ssl_netty4
  xpack.security.enabled: false
  ```
  **Default configurations of elasticsearch.yml** will be as in the attached template file [elasticsearch-configuration-template.yml](attachments/elasticsearch-configuration-template.yml).

  ```
  Note:
  The keystore file and its passwords keystore_pass & key_pass are shipped out of the product by default. This may not be safe for production environment. For production setup, you can generate your own certificates (keystore and trustore) and configure here.
  ```

**Option 2) :  Obfuscated or hashed credentials**

- Exposing plain text credentials is very insecure for the application. Hence you should used obfuscated credentials.
- ReadonlyREST supports obfuscating the credentials by hashing the credentials using SHA256 algorithm.
- You can use the tool <https://xorbin.com/tools/sha256-hash-calculator> to hash your credentials. The hashed credentials can be used in the configuration with the property ***auth\_key\_sha256*** .
- In the above configuration, replace the auth\_key configuration with auth\_key\_sha256 as below,

```
readonlyrest:    
    access_control_rules:
 
    - name: "Require HTTP Basic Auth"
      type: allow
      auth_key_sha256: 927d5619ff87227be6ca8a2cc9ee68c11dd7a08d64d1e20bdc8d86254850b418
           
    ssl:
      enable: true
      keystore_file: "node-0-keystore.jks"
      keystore_pass: a362fbcce236eb098973
      key_pass: a362fbcce236eb098973
      client_authentication: true
```

- Save the configuration file readonlyrest.yml.

  Note : Ignore the below step if it was already done through option 1) explained above

- Now open <***SAG\_Root>/InternalDataStore/config/elasticsearch.yml*** and add the below configuration statement and save the file.

  This will be used for HTTPS connection for Elasticsearch.
  ```
  http.type: ssl_netty4
  xpack.security.enabled: false
  ```
  
## **Step 4: Secure the internode communication**
If you have clustered the InternalDataStore instances, then the communication between them can be secured in this step as explained below.

- Open the file <***SAG\_Root>/InternalDataStore/config/readonlyrest.yml*** and add the lines to the last
  ```
  ssl_internode:
    keystore_file: "node-0-keystore.jks"
    keystore_pass: a362fbcce236eb098973
    key_pass: a362fbcce236eb098973
   ```
  For ssl\_internode also, the keystore should be stored in the same directory with elasticsearch.yml and readonlyrest.yml. 

  This config must be added to all nodes taking part in encrypted communication within cluster.

- So the consolidated content of readonlyrest.yml will be as below,
  ```
  readonlyrest:    
      access_control_rules:
   
      - name: "Require HTTP Basic Auth"
        type: allow
        auth_key_sha256: 927d5619ff87227be6ca8a2cc9ee68c11dd7a08d64d1e20bdc8d86254850b418
             
      ssl:
        enable: true
        keystore_file: "node-0-keystore.jks"
        keystore_pass: a362fbcce236eb098973
        key_pass: a362fbcce236eb098973
   
      ssl_internode:
        keystore_file: "node-0-keystore.jks"
        keystore_pass: a362fbcce236eb098973
        key_pass: a362fbcce236eb098973
        client_authentication: true
  ```

- Add the below configuration to the file <***SAG\_Root>/InternalDataStore/config/elasticsearch.yml*** and save the file. 
  ```
  transport.type: ror_ssl_internode
  ```

  This config must be added to all nodes taking part in encrypted communication within cluster.

- Start the InternalDataStore node and verify it is protected by accessing the node using HTTPS URL https://<*host*>:9240 with the given username/password.

  Confirmation for the installation/availability of ReadonlyREST plugin in InternernalDataStore startup console  

  ![](attachments/image3.png)

  Confirmation message for ReadonlyREST plugin has been loaded/started successfully

  ![](attachments/image4.png)

  Accessing the InternalDataStore with its HTTPS URL

  ![](attachments/image5.png)

  ![](attachments/image6.png)

## **Step 5: Changing Kibana configurations to connect to Elasticsearch**
Now we need to modify the Kibana server configurations to connect to the Elasticsearch securely over HTTPS port using basic authentication details.

- Open the file  ***<SAG\_Root>\profiles\IS\_default\apigateway\dashboard\config\kibana.yml***.
- Remove the comments and update the following properties given below,
  - elasticsearch.customHeaders.Authorization: "Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=" 
  - elasticsearch.ssl.verificationMode: certificate
  - elasticsearch.ssl.certificateAuthorities: <_file path of your root-ca.pem certificate_>
  - elasticsearch.hosts: https://<_hostname_>:9240

Here **QWRtaW5pc3RyYXRvcjptYW5hZ2U=** is **Base64** encoded format of username: password - "**Administrator:manage**" .Please refer <https://forum.readonlyrest.com/t/kibana-error-401/1878>.

- After changing these configurations open ***uiconfiguration.properties*** file at ***<SAG\_Root>\profiles\IS\_default\apigateway\config*** and set **apigw.kibana.autostart** to **false**.

Sample configuration of kibana.yml is as below,

```
server.port: 9405
server.host: "0.0.0.0"
server.basePath: "/apigatewayui/dashboardproxy"
elasticsearch.hosts: "https://localhost:9240"
kibana.index: "gateway_<tenant-name>_dashboard"
elasticsearch.customHeaders.Authorization: "Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=" 
elasticsearch.ssl.verificationMode: certificate
elasticsearch.ssl.certificateAuthorities: <SAG_Root>/InternalDataStore/sagconfig/root-ca.pem
pid.file: kibana.pid
console.enabled: false
```

## **Step 6: Changing API Gateway configurations to connect to Elasticsearch**
Finally change the API Gateway configurations to connect to InternalDataStore securely. Follow the below steps.

- Go to ***<SAG\_Root>/IntegrationServer/instances/<Instance\_Name>/packages/WmAPIGateway/config/resources/elasticsearch*** and open ***config.properties*** file. Uncomment the following properties and provide the values for them as below, 
  - pg.gateway.elasticsearch.http.username=Administrator
  - pg.gateway.elasticsearch.http.password=manage
  - pg.gateway.elasticsearch.https.truststore.filepath=*<SAG\_Root>*/InternalDataStore/sagconfig/truststore.jks
  - pg.gateway.elasticsearch.https.truststore.password=2c0820e69e7dd5356576
  - pg.gateway.elasticsearch.https.enabled=true
- After making all the configurations, **start the InternalDataStore manually.**
- When InternalDataStore is up and running,  **start the API Gateway** and you would be able to login and create APIs.
- Now **start the Kibana server manually** (To start kibana server manually run ***kibana.bat*** file located at ***<SAG\_Root>/profiles/IS\_default/apigateway/dashboard/bin***)
- Analytics page should be accessible without any challenge window for user credentials.

## **Step 7: Configuring ReadonlyREST with user generated certificates (optional)**
Here we can see an example with a self-signed certificate which can be generated using Java Keytool.

Shut down API Gateway, Kibana and InternalDataStore.

1. ***Generate keystore.jks :***

    command to generate keystore using Keytool
    ```
    keytool -genkey -alias <alias name> -keyalg RSA -keystore <File path>\keystore.jks -storetype JKS
    ```
    Example :

    ![](attachments/image7.png)

    Replace ***<SAG\_Root>/InternalDataStore/config/keystore.jks*** file with this ***keystore.jks*** file and update the properties ***keystore\_pass*** and ***key\_pass*** in ***<SAG\_Root>/InternalDataStore/config/readonlyrest.yml***.

    ```
     readonlyrest:    
         access_control_rules:
      
         - name: "Require HTTP Basic Auth"
           type: allow
           auth_key: Administrator:manage
                
         ssl:
           enable: true
           keystore_file: "keystore.jks"
           keystore_pass: <<Keystore pass>>
           key_pass: <<Key pass>>
           client_authentication: true
    ```

 2. **Export certificate from the keystore :**
 
     Command to export the certificate from the keystore
     ```
     keytool -export -alias <alias name> -keystore <keystore file path> -rfc -file <filename>.cert
     ```
     Example :

     ![](attachments/image8.png)

     Update  this certificate name in kibana configuration property ***elasticsearch.ssl.certificateAuthorities*** in ***<SAG\_Root>\profiles\IS\_default\apigateway\dashboard\config\kibana.yml***.

     Example :
     ```
     elasticsearch.ssl.certificateAuthorities: C:/work/APIGateway/test.cert
     ```

 3. **Generate truststore from the certificate :**
 
     Command to generate truststore file 
     ```
     keytool -import -alias <alias name> -file <Certificate file> -storetype JKS -keystore <File location and file name for truststore>.jks
     ```
     Example :

     ![](attachments/image9.png)

     After successful creation of the the truststore file, update the properties **pg.gateway.elasticsearch.https.truststore.filepath** and **pg.gateway.elasticsearch.https.truststore.password**  in API Gateway configuration file ***config.properties***  located at ***<SAG\_Root>/IntegrationServer/instances/<Instance\_Name>/packages/WmAPIGateway/config/resources/elasticsearch***.

     Example :
     ```
     pg.gateway.elasticsearch.https.truststore.filepath=C:/work/APIGateway/trustore.jks

     pg.gateway.elasticsearch.https.truststore.password=<your trustore password>
     ```
     After making all the configurations, **start the InternalDataStore manually.**

     When InternalDataStore is up and running,  **start the API Gateway** and you would be able to login and create APIs.

     Now **start the Kibana server manually** (To start kibana server manually run ***kibana.bat*** file located at ***<SAG\_HOME>/profiles\IS\_default\apigateway\dashboard\bin***).

     Analytics page should be accessible without any challenge window for user credentials.
# **Securing InternalDataStore Using *Search Guard***
## **Step 1: Download Search Guard plugin compatible with Elasticsearch 7.13.0**
This section explains how to download the Search Guard plugin of the Elasticsearch 7.13.0 version used by the InternalDataStore.

You can download the **Search Guard plugin version 51.0.0 compatible for Elasticsearch 7.13.0** from <https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.13.0-51.0.0/search-guard-suite-plugin-7.13.0-51.0.0.zip> and store it in your file system.

You can also refer the compatible version of Search Guard for different Elasticsearch versions here : <https://docs.search-guard.com/latest/search-guard-versions>.
## **Step 2: Installation and Initialization of Search Guard plugin**
This section explains how to install the Search Guard plugin which is downloaded before.

- Stop the API Gateway server.
- Open the command prompt to the location <***SAG\_Root>/InternalDataStore/bin***.
- Issue the command ***elasticsearch-plugin.bat install file:///<_Search Guard plugin file location in the file system_>*** and give 'y' when the installation procedure prompts for additional required permissions it requires and confirm the installation is completed with the message displayed as **"Installed search-guard-7"**.

Example :

![](attachments/image10.png)



- After successful installation, copy the folder ***sagconfig*** from ***<SAG\_Root>/IntegrationServer/instances/<Instance\_Name>/packages/WmAPIGateway/config/resources/elasticsearch/*** to ***<SAG\_Root>/InternalDataStore/***.
- Now copy the sample keystore and trustore files (which will be used latter in below steps) ***node-0-keystore.jks*** and ***truststore.jks*** from <***SAG\_Root>/InternalDataStore/sagconfig***  to ***<SAG\_Root>/InternalDataStore/config***.
- Open **<SAG\_Root>/InternalDataStore/config/elasticsearch.yml** file. Remove all the properties that start with "**searchguard**" if such present and **add the Search Guard properties** as given below and save the file.

**Search Guard properties**
```
searchguard.ssl.transport.keystore_type: JKS

searchguard.ssl.transport.keystore_filepath: node-0-keystore.jks

searchguard.ssl.transport.keystore_alias: cn=node-0

searchguard.ssl.transport.keystore_password: a362fbcce236eb098973

searchguard.ssl.transport.truststore_type: "JKS"

searchguard.ssl.transport.truststore_filepath: truststore.jks

searchguard.ssl.transport.truststore_alias: root-ca-chain

searchguard.ssl.transport.truststore_password: 2c0820e69e7dd5356576

searchguard.ssl.transport.enforce_hostname_verification: false

searchguard.ssl.transport.resolve_hostname: false

searchguard.ssl.transport.enable_openssl_if_available: true

searchguard.ssl.http.enabled: true

searchguard.ssl.http.keystore_type: JKS

searchguard.ssl.http.keystore_filepath: node-0-keystore.jks

searchguard.ssl.http.keystore_alias: cn=node-0

searchguard.ssl.http.keystore_password: a362fbcce236eb098973

searchguard.ssl.http.truststore_type: JKS

searchguard.ssl.http.truststore_filepath: truststore.jks

searchguard.ssl.http.truststore_alias: root-ca-chain

searchguard.ssl.http.truststore_password: 2c0820e69e7dd5356576

searchguard.ssl.http.clientauth_mode: OPTIONAL

searchguard.enable_snapshot_restore_privilege: true

searchguard.check_snapshot_restore_write_privileges: true

searchguard.restapi.roles_enabled: ["SGS_ALL_ACCESS"]

searchguard.authcz.admin_dn:

- "CN=sgadmin"

xpack.security.enabled: false
```

Details about the above search guard properties is given below,

|**Item**|**Desc**|**Possible Values**|**Default**|
| ----------- | ------------- | ------ | -------- |
|||**TRANSPORT ( 2-Way authentication is enabled by default)**||
|searchguard.ssl.transport.keystore\_type|Type of keystore|JKS, PKCS12|JKS|
|searchguard.ssl.transport.keystore\_filepath|Location of the keystore|||
|searchguard.ssl.transport.keystore\_alias|Keystore entry name if there are more than one entries.|||
|searchguard.ssl.transport.keystore\_password|Password to access keystore.|||
|searchguard.ssl.transport.truststore\_type|Type of truststore|JKS, PKCS12|JKS|
|searchguard.ssl.transport.truststore\_filepath|Location of the truststore|||
|searchguard.ssl.transport.truststore\_alias|Truststore entry name if there are more than one entries.|||
|searchguard.ssl.transport.truststore\_password|Password to access truststore.|||
|searchguard.ssl.transport.enforce\_hostname\_verification|If true, the hostname mentioned in certificate will be validated. We set this to *false* as ours is general purpose self signed certs.|true / false|true|
|searchguard.ssl.transport.resolve\_hostname|Applicable only if above property is true. If true, the hostname will be resolved against the DNS server. We set this to false as ours is general purpose self signed certs.|true / false|true|
|searchguard.ssl.transport.enable\_openssl\_if\_available|Use if *OpenSSL* is available instead of JDK SSL.|true / false|true|
|||**HTTP**||
|searchguard.ssl.http.enabled|To enable the SSL for REST interface ( HTTP). We set this to true.|true / false|false|
|searchguard.ssl.http.keystore\_type|Type of keystore|JKS, PKCS12|JKS|
|searchguard.ssl.http.keystore\_filepath|Location of the keystore|||
|searchguard.ssl.http.keystore\_alias|Keystore entry name if there are more than one entries.|||
|searchguard.ssl.http.keystore\_password|Password to access keystore.|||
|searchguard.ssl.http.truststore\_type|Type of truststore|JKS, PKCS12|JKS|
|searchguard.ssl.http.truststore\_filepath|Location of the truststore|||
|searchguard.ssl.http.truststore\_alias|Truststore entry name if there are more than one entries|||
|searchguard.ssl.http.truststore\_password|Password to access truststore.|||
|searchguard.ssl.http.clientauth\_mode|<p>Option to enable 2-way authentication.</p><p>REQUIRE : Client will be challenged for client certificate.</p><p>OPTIONAL : Will be used if client certificate is available</p><p>NONE : Ignore client certificate even if it's available.</p>|<p>REQUIRE,</p><p>OPTIONAL,</p><p>NONE</p>|OPTIONAL|
|||**Search Guard Admin**||
|searchguard.authcz.admin\_dn|Search Guard maintains all the data in a index called "searchguard". This is accessible to only users ( client cert which will be passed in sdadmin command) configured here.|||
|||**Misc**||
|searchguard.cert.oid|<p>All certificates used by the nodes on transport level need to have the oid field set to a specific value.This oid value is checked by</p><p>Search Guard to identify if an incoming request comes from a trusted node in the cluster or not. In the former case, all actions are allowed,</p><p>in the latter case, privilege checks apply. Plus, the oid is also checked whenever a node wants to join the cluster.</p>||'1.2.3.4.5.5'|
|searchguard.config\_index\_name|Index where all the security configuration is stored. It's not configurable for now but in the future||searchguard|
|searchguard.enable\_snapshot\_restore\_privilege<br>searchguard.check\_snapshot\_restore\_write\_privileges|To perform snapshot and restore operations, a user needs to have special privileges assigned. These two lines enable these privileges|||
|searchguard.restapi.roles\_enabled|Tells Search Guard which Search Guard roles can access the REST Management API to perform changes to the configuration|||


**Default configurations of elasticsearch.yml** will be as in the attached template file [elasticsearch-configuration-template.yml](attachments/elasticsearch-configuration-template.yml).

- Now shutdown and restart the InternalDataStore. 
- Go to the location ***<SAG\_Root>/InternalDataStore/plugins/search-guard-7/tools*** and execute the below command,

  For Windows :

***sgadmin.bat -cd ..\\..\\..\sagconfig\ -ks ..\\..\\..\sagconfig\sgadmin-keystore.jks -kspass 49fc2492ebbcfa7cfc5e -ts ..\\..\\..\\sagconfig\truststore.jks -tspass 2c0820e69e7dd5356576 -nhnv -p 9340 -cn SAG\_EventDataStore***.

For Linux :

***sgadmin.sh -cd ../../../sagconfig -ks ../../../sagconfig/sgadmin-keystore.jks -kspass 49fc2492ebbcfa7cfc5e -ts ../../../sagconfig/truststore.jks -tspass 2c0820e69e7dd5356576 -nhnv -p 9340 -cn SAG\_EventDataStore***.

This will initialize the InternalDataStore.

Example :

![](attachments/image11.png)
```
Note

The Password -kspass 49fc2492ebbcfa7cfc5e and –tspass 2c0820e69e7dd5356576 are default passwords for keystore and truststore and the default certificates are not safe for production.
```
## **Step 3: Protect InternalDataStore with Basic Authorization**
In this section let us see how an user can be provisioned in the Search Guard plugin to provide a http basic authentication.

- Adding User name :  
  Go to ***<SAG\_Root>\InternalDataStore\sagconfig*** and open ***sg\_roles\_mapping.yml*** file. Add the username (e.g. testuser) in the **users** list as given in the below image.
  
  ![](attachments/image12.png)
- Adding password

  Before providing the password it must be converted into hash code. To generate the hash code for your password, execute ***<SAG\_Root>\InternalDataStore\plugins\search-guard-7\tools\hash.bat.***

  Type the password, press enter and it will generate the hash code as given in below image.

  ![](attachments/image13.png)

  Now open ***sg\_internal\_users.yml*** file located at ***<SAG\_Root>\InternalDataStore\sagconfig***  and add the username and password as given in the below image.

  ![](attachments/image14.png)

  After completing the configurations, initialize Search Guard plugin again by executing the ***sgadmin.bat*** command as we did before. After initialization shutdown and restart the InternalDataStore. 

  Verify if InternalDataStore is protected, by accessing the node using HTTPS URL https://<_host_>:9240 with the given username/password.

  ![](attachments/image15.png)

  ![](attachments/image16.png)
## **Step 4: Changing Kibana configurations to connect to Elasticsearch**
Now we need to modify the Kibana server configurations to connect to the Elasticsearch securely over HTTPS port using basic authentication details.

- Open the file  ***<SAG\_Root>\profiles\IS\_default\apigateway\dashboard\config\kibana.yml***.
- Remove the comments and update the following properties given below, 
  - elasticsearch.customHeaders.Authorization: "Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=" 
  - elasticsearch.ssl.verificationMode: certificate
  - elasticsearch.ssl.certificateAuthorities: <_file path of your root-ca.pem certificate_>
  - elasticsearch.hosts: https://<_hostname_>:9240

 Here **QWRtaW5pc3RyYXRvcjptYW5hZ2U=** is Base64 encoded format of username: password - "**Administrator:manage**" .Please refer [**https://forum.readonlyrest.com/t/kibana-error-401/1878**](https://forum.readonlyrest.com/t/kibana-error-401/1878).

- After changing these configurations open ***uiconfiguration.properties*** file located at ***<SAG\_Root>\profiles\IS\_default\apigateway\config*** and set **apigw.kibana.autostart** to **false**.

Sample configuration of kibana.yml is as below,
```
server.port: 9405
server.host: "0.0.0.0"
server.basePath: "/apigatewayui/dashboardproxy"
elasticsearch.hosts: "https://localhost:9240"
kibana.index: "gateway_<tenant-name>_dashboard"
elasticsearch.customHeaders.Authorization: "Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U="
elasticsearch.ssl.verificationMode: certificate
elasticsearch.ssl.certificateAuthorities: <SAG_Root>/SoftwareAG/InternalDataStore/sagconfig/root-ca.pem
pid.file: kibana.pid
console.enabled: false
```
## **Step 5: Changing API Gateway configurations to connect to Elasticsearch**
Finally change the API Gateway configurations to connect to InternalDataStore securely. Follow the below steps.

- Go to ***<SAG\_Root>/IntegrationServer/instances/<Instance\_Name>/packages/WmAPIGateway/config/resources/elasticsearch*** and open ***config.properties*** file. Uncomment the following properties and provide the values for them as below, 
  - pg.gateway.elasticsearch.http.username=Administrator
  - pg.gateway.elasticsearch.http.password=manage
  - pg.gateway.elasticsearch.https.truststore.filepath=*<SAG\_Root>*/InternalDataStore/sagconfig/truststore.jks
  - pg.gateway.elasticsearch.https.truststore.password=2c0820e69e7dd5356576
  - pg.gateway.elasticsearch.https.enabled=true
- After making all the configurations, **start the InternalDataStore manually.**
- When InternalDataStore is up and running,  **start the API Gateway** and you would be able to login and create APIs.
- Now **start the Kibana server manually** (To start kibana server manually run ***kibana.bat*** file located at ***<SAG\_Root>/profiles/IS\_default/apigateway/dashboard/bin***)
- Analytics page should be accessible without any challenge window for user credentials.
## **Step 6: Configuring Search Guard with user generated certificates (optional)**
The API Provider can generate his own certificates to be used with Search Guard instead of the default certificates that are shipped with API Gateway. To achieve this, Search Guard provides an offline TLS tool, using which all the required certificates can be generated for running Search Guard in a production environment. Follow the below steps to generate certificates using Search Guard offline TLS tool.

Download the tool zip file from <https://maven.search-guard.com/search-guard-tlstool/1.8/search-guard-tlstool-1.8.zip> (the same can be found in the [attachments](attachments/search-guard-tlstool-1.8.zip) and unzip it to a directory. Create a yaml file at ***<_OfflineTool Installation Directory_>\config***. On executing the TLS tool command, it will read the node and certificate configuration settings from this yaml file and outputs the generated files in a configured directory. The sample file is given below. Please find the attachments for the sample file, [***Certificates.yml***](attachments/Certificates.yml).

![](attachments/image17.png)

After configuring the yaml file run the below command to generate the required certificates.
***<_OfflineTool Installation Directory_>/tools/sgtlstool.bat -c ../config/<_YAML file name_>.yml -ca -crt***.
The generated certificates can be found in ***<_OfflineTool Installation Directory_>/tools/out***.

![](attachments/image18.png)

For further details on this refer the link provided in the References. It is mandatory to copy the certificates listed below from ***<_OfflineTool Installation Directory_>/tools/out*** to ***<SAG\_Root>/InternalDataStore/config*** folder.

- Dinesh-node-1.key
- Dinesh-node-1.pem
- Dinesh-node-1\_http.pem
- Dinesh-node-1\_http.key
- Dinesh-client.pem
- Dinesh-client.key
- root-ca.pem
- root-ca.key

Now configure the generated certificates in the InternalDataStore  elasticsearch.yml file.

![](attachments/image19.png)

After completing all the above steps start the InternalDataStore  manually. After InternalDataStore is up, since the Search Guard is not initialized with the latest certificates, a log message would be shown saying that the Search Guard is not initialized. The following section provide the steps to initialize the Search Guard with the generated certificates.

- Open command prompt and change directory to ***<SAG-Home>\InternalDataStore \plugins\search-guard-7\tools***.
- Execute the command ***sgadmin.sh -cd ..\\..\\..\\sagconfig –nhnv –icl –cacert ..\\..\\..\config\root-ca.pem -cert ..\\..\\..\\config\Dinesh-client.pem -key ..\\..\\..\\config\Dinesh-client.key -keypass <_your certificate password_> -p 9340*** . A log "Done with success" will show up.
- Now shutdown and restart the InternalDataStore . The InternalDataStore will now use the generated certificates for SSL communication.

  Additional Steps while using user generated certificates 

  using a key tool import generated  pem certificate "root-ca.pem"  into truststore.  

  First, let us create an empty truststore and then import pem certificate into it.
  
  Generate empty truststore :
  ```
  keytool -genkey -keyalg RSA -alias endeca -keystore truststore.jks

  keytool -delete -alias endeca -keystore truststore.jks
  ```

  ![](attachments/image20.png)

  command for importing pem file into truststore
  ```
  keytool -import -v -trustcacerts -alias endeca-ca -file root-ca.pem -keystore truststore.jks 
  ```
  After this, use the generated truststore  in step 5.

# **Troubleshooting : Search Guard Plugin**

|**#**|**Problem**|**Solution**|
| ----------- | ------------- | ------ |
|1|Search Guard may not be initialized. Initialize Search Guard Using sgadmin tool.|Make sure that Search Guard is initialized properly using the steps given above|
|2|<p>Error in ElasticSearch:</p><p>Speaks http plaintext instead of SSL, will close the channel</p>|<p>It means Kibana or API Gateway is still communicating with Elasticsearch in HTTP.</p><p>Configure the https protocol and certificates in kibana.yml of Kibana server and config.properties in API Gateway</p>|
|3|<p>Error while running sgtlstool.bat or enable\_ssl.bat</p><p>The system cannot find the path specified.</p>|<p>It means the JAVA\_HOME was not set.</p><p>configuring JAVA\_HOME will resolve the issue.</p>|
|4|Search Guard License Type: TRIAL, valid<br>Your Search Guard license expires in 17 days.|Add the below line in elasticsearch.yml and restart elastic search<br>searchguard.enterprise\_modules\_enabled: false|

# **References**
ReaoonlyREST :

- Refer <https://readonlyrest.com/> to know about ReadonlyREST
- Refer <https://github.com/beshu-tech/readonlyrest-docs/blob/master/elasticsearch.md> to know more about securing Elasticsearch with ReadonlyREST
- Refer <https://forum.readonlyrest.com/> - the forum for ReadonlyREST.

Search Guard :

- Refer <https://docs.search-guard.com/latest/search-guard-installation> for Search Guard installation documentation
- Refer <https://docs.search-guard.com/latest/offline-tls-tool> for detailed understanding of Search Guard offline TLS tool
- Refer <https://docs.search-guard.com/latest/search-guard-versions> for Search Guard and Elasticsearch support matrix

# **Downloadable artifacts**
- [Certificates.yml](attachments/Certificates.yml) file for Search Guard certificates configuration
- [search-guard-tlstool-1.8.zip](attachments/search-guard-tlstool-1.8.zip), Search Guard offline TLS tool

