# Upgrading major versions in zero downtime

Supported paths: 

10.5 Fix 9 to 10.7 or above

## Overview of the tutorial

This tutorial explains in detail the steps needed for upgrading API Gateway in zero downtime for major versions like 10.5 to 10.7, 10.7 to 10.11, etc. This is applicable for both standalone and cluster deployments.

## Required knowledge

The tutorial assumes that the reader has,

*   a basic knowledge on the API Gateway as a product

## Why?

The existing migration approach incurs a downtime while doing upgrade. This approach provides an upgrade process with zero downtime.

## Prerequisite steps

Complete the below prerequisites to make you ready to get into the details of upgrading API Gateway in zero downtime.

*   Old API Gateway instance(s) should be running
*   Create a quiesce port in old API Gateway instance(s). For a cluster, this should be done for each instance. Refer IS user guide for creating a quiesce port. Anyway a sample is given below in the steps.

> **Important Note**: **To avoid known issue in 10.7 migration **

When you migrate from 10.5 to 10.7 version of API Gateway, the fields such as "gatewayEndpoints" and "provider" are not migrated to 10.7 from 10.5.

Before performing the migration, add the two fields in the following location
<Installation_Location>\IntegrationServer\instances\default\packages
\WmAPIGateway\bin\migrate\MigrationESHandler.xml
under the property name 'typesFields' and entry key 'apis'.

This issue will be fixed in the 10.7 fix 4.

## Details

API Gateway follows Blue-Green deployment approach to upgrade to newer major version in zero downtime. In such deployment scenario, old instance will be allowed to run and serve the transactions while the new version of API Gateway is being prepared with data migration. The data migration happens in two phases. In the first phase, the old instance is blocked for design time(core) data updates and all the design time(core) data would be migrated to the new datastore, while the new API Gateway version is running. Next the new version is restarted with the migrated design time data and the endpoint is added to the load balancer. At this time the transactions are served by both the old and new versions. In the second phase, all the transactions to the old version is blocked and the logs and events data are migrated to the new version while it is serving the transactions.

In this section we will go through the steps for doing zero downtime upgrade of API Gateway.  The below diagram show the entire workflow for this use case.

![](attachments/Workflow.jpg)

The steps are given below.

### Step 1: Start new API Gateway instance(s)

Install the new API Gateway instance(s) and do the below prerequisites.

#### a. IS/File system configurations and custom packages

As zero downtime upgrade deals only with the migration of datastore data, the Administrator has to take care of migrating the non datastore configurations such as file system configurations, ports configurations (if port clustering is disabled) and custom ESB packages to the new API Gateway instance(s) before running the migration of data.  

> **Note**: Most of the configurations can be configured using externalized configurations. For information on externalization,  refer **[this](https://tech.forums.softwareag.com/t/starting-api-gateway-using-externalized-configurations/237312)** tech community article.

The configurations are listed below for your convenience.

##### File system configurations

| Configuration                      | File name                                                    | File location                                                |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Elasticsearch configuration        | elasticsearch.yml                                            | SAGInstallDir/InternalDataStore/config/                      |
| Elasticsearch client configuration | config.properties                                            | SAGInstallDir/IntegrationServer/instances/<br/>instance_name/packages/WmAPIGateway/config/<br/>resources/elasticsearch/ |
| Kibana configuration               | kibana.yml                                                   | SAGInstallDir/profiles/instance_name/<br/>apigateway/dashboard/config/ |
| Master password                    | mpw.dat                                                      | SAGInstallDir/profiles/instance_name/<br/>configuration/security/passman/ |
| UI configurations                  | uiconfiguration.properties                                   | SAGInstallDir/profiles/instance_name/<br/>apigateway/config/ |
| SAML group mapping                 | saml_groups_mapping.xml                                      | SAGInstallDir/IntegrationServer/instances/<br/>instance_name/packages/WmAPIGateway/config/<br/>resources/security/ |
| WebApp settings                    | com.softwareag.catalina.connector.http.pid-apigateway.properties<br/>com.softwareag.catalina.connector.https.pid-apigateway.properties | SAGInstallDir/profiles/instance_name/<br/>configuration/<br/>com.softwareag.platform.config.propsloader/ |

##### Server ports configuration

If the portClusteringEnabled extended setting is set to false, the server ports should be created in each instance by the Administrator.

##### SAML SSO configuration

Ensure that the following files in SAML SSO configuration (SSO configuration done in API Gateway Admin UI) are accessible to the new instance. If not, manually copy those files to the new instance.

*   IDP metadata  
*   Gateway metadata 
*   Keystore 

##### Custom ESB packages

Also make sure that all the custom packages are installed and ready in the new instance(s).

#### b. Configure reindex.remote.whitelist in elasticsearch.yml

Remote datastore host has to be explicitly allowed in elasticsearch.yml using the `reindex.remote.whitelist` property.

Configure `reindex.remote.whitelist` in *SAG/InternalDataStore/config/elasticsearch.yml* file and set the value of old datastore host and port like `reindex.remote.whitelist: localhost:9200`. 

> **Note**: For a cluster this should be done in all instances.

#### c. Configurations to do if old datastore is SSL protected

If the old datastore is SSL protected, follow one of the below ways to configure the new datastore to connect to old datastore in a secure way.

> **Note**: For a cluster this should be done in all instances.

##### i).  Configuring SSL parameters in elasticsearch.yml

Configure the SSL related reindex settings in the new datastore's elasticsearch.yml file. Please refer **[this](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/docs-reindex.html#reindex-ssl)** Elasticsearch documentation for reindex SSL settings. For a cluster this should be done in all instances.

##### ii). Importing old datastore certificates into new datastore JVM

Add the old instance certificates (public key) in to the new instance datastore JVM's trust store. For e.g, in case of internal datastore we need to add the public keys to the trust store cacerts file located at *\jvm\jvm\jre\lib\security*.

> **Note**: If external Elasticsearch is used for the new API Gateway instance then the certificates should be imported to its corresponding JVM

Below is a sample command to import the trust store of old datastore in to the new datastore JVM.

```
$>\jvm\jvm\bin\keytool -import -keystore \jvm\jvm\jre\lib\security\cacerts -file <truststore.jks> -alias <alias>
```

| Property       | **Detail**                                                   | **Example**             |
| -------------- | ------------------------------------------------------------ | ----------------------- |
| truststore.jks | Trust store used in Elasticsearch. Provide the full path of the trust store. It will be available at *\WmAPIGateway\config\resources\elasticsearch\config.properties* file with property `pg.gateway.elasticsearch.https.truststore.filepath` | *sagconfig/root-ca.jks* |
| alias          | This is the alias used in Elasticsearch                      | wm.sag.com              |

Now start the new API Gateway instance(s) with the new datastore (cluster and Terracotta cluster).

### Step 2: Clean data in new datastore

> **Note**: This operation is performed at new API Gateway instance. For a cluster, do this in one of the nodes.

As a first step after starting the new API Gateway instance(s), the data in the datastore should be cleaned. For that, invoke the below REST API.

`POST /rest/apigateway/migration`

```json
{
    "action": "clean"
}
```

For safety reasons, this API will take backup of the data before cleaning it. Hence make sure that `path.repo` property is configured in elasticsearch.yml before invoking this API otherwise you will get an error response with 400 status code.

> **Note**: If you don't want to take backup when this API is invoked set `"backup": false` in the JSON payload.

#### Clean action status

When the clean operation is completed, API Gateway sends out a notification with the result details through registered webhooks. Or you can invoke the below REST API to check for the current status of the operation.

`GET /rest/apigateway/migration/status?action=clean`

`"status": "success"` means the data is cleaned successfully.

#### Rollback on error

If the clean API invocation fails with an error or the status returned with a failure, stop proceeding with the next steps. Contact Software AG support team for help with all the relevant logs for further analysis.

### Step 3: Put old API Gateway instance(s) into Quiesce mode for design time

> **Note**: This operation is performed at old API Gateway instance(s). For a cluster, do this at each node as Quiesce mode is performed at instance level.

API Gateway data in the datastore is migrated in two phases. In first phase, only the design time data like APIs, Applications, Policies, etc. will be migrated. The runtime data like audit logs, transaction logs, performance metrics, etc. will be migrated in the next phase that is after the runtime transactions to the old instance(s) are stopped. This will be done after the new instance(s) is up and running with the new data and runtime traffic is allowed to it.

Before migrating design time data in the first phase, all the updates to them through UI and REST APIs need to be blocked. This can be achieved by the Quiesce mode capability available in API Gateway.

Invoke the below REST API at old API Gateway instance(s) to put it into Quiesce mode for design time.

`PUT /rest/apigateway/quiescemode`

```json
{
    "enable": true,
    "block": "designtime"
}
```

If the invocation is successful the REST API will return with 200 OK.

```json
{
    "enable": true,
    "block": "designtime",
    "status": "success"
}
```

Now all the design time invocations to the old instance(s) will be blocked and API Gateway will return 503 to the client. Only the below requests will be allowed:

- All GET requests
- /rest/apigateway/quiescemode
- /rest/apigateway/search
- /rest/facade/apigateway/searchApis

#### Quiesce mode for design time operation status

When the Quiesce mode for design time is complete, API Gateway sends out a notification with the result details through registered webhooks. Or you can invoke the below REST API to check for the current status of the operation.

`GET rest/apigateway/quiescemode`

`"status": "success"` means the Quiesce mode for design time is complete.

#### Rollback on error

If the Quiesce mode for design time API invocation fails with an error or the status returned with a failure, stop proceeding with the next steps and disable the Quiesce mode for design time in all the nodes and bring them back to normal state. Contact Software AG support team for help with all the relevant logs for further analysis.

### Step 4: Migrate design time data

> **Note**: This operation is performed at new API Gateway instance.  For a cluster, do this in one of the nodes.

When the old API Gateway instance(s) is put into Quiesce mode for design time, it is now safe to migrate the design time data to new API Gateway instance's datastore. .

Invoke the below REST API at the new API Gateway instance to migrate the design time data. For a cluster, do this at only one of the instances. If the old datastore is protected with basic auth, send the username and password in the request payload.

`POST /rest/apigateway/migration`

```json
{
    "action": "reindex",
    "indicesType": "core",
    "sourceElasticsearch": {
        "url": "http://localhost:9200",
        "username": "username",
        "password": "password"
    },
    "properties": {
        "apigateway.migration.srcTenantName": "apigateway",
        "apigateway.migration.batchSize": 100,
        "apigateway.migration.logLevel": "info",
        "apigateway.migration.reindex.status.check.sleep.interval": 5000,
        "apigateway.migration.batchSize.gateway_{0}_apis": 50,
        "apigateway.migration.batchSize.gateway_{0}_log": 100,
        "apigateway.migration.batchSize.gateway_{0}_audit_auditlogs": 50,
        "apigateway.migration.batchSize.gateway_{0}_analytics_transactionalevents": 50
    }
}
```

#### Reindex action status

Since this is a long operation, the REST API will initiate the action and return with 201 Accepted, if the invocation is successful.

When the reindex operation is completed, API Gateway sends out a notification with the result details through registered webhooks. Or you can invoke the below REST API to check for the current status of the operation.

`GET /rest/apigateway/migration/status?action=reindex`

`"status": "success"` means the reindex is completed successfully.

#### Rollback on error

If the reindex API invocation for design time data fails with an error or the status returned with a failure, stop proceeding with the next steps and disable the Quiesce mode for design time in all the nodes and bring them back to normal state. Clean the data and retry. If the error persists contact Software AG support team for help with all the relevant logs for further analysis.

### Step 5: Transform design time data

> **Note**: This operation is performed at new API Gateway instance. For a cluster, do this in one of the nodes.

After the design time data is migrated to new datastore, now we need to transform the data to be compatible with the new API Gateway instance(s). Invoke the below REST API to transform the data.

`POST /rest/apigateway/migration`

```json
{
    "action": "transform"
}
```

#### Transform action status

Since this is a long operation, the REST API will initiate the action and return with 201 Accepted, if the invocation is successful.

When the reindex operation is completed, API Gateway sends out a notification with the result details through registered webhooks. Or you can invoke the below REST API to check for the current status of the operation.

`GET /rest/apigateway/migration/status?action=transform`

`"status": "success"` means the transform is completed successfully.

#### Rollback on error

If the transform API invocation for design time data fails with an error or the status returned with a failure, stop proceeding with the next steps and disable the Quiesce mode for design time in all the nodes and bring them back to normal state. Clean the data and retry from reindexing of design time data. If the error persists contact Software AG support team for help with all the relevant logs for further analysis.

### Step 6: Restart new API Gateway instance(s)

Now the design time data is migrated to the new datastore and transformed to be compatible with the new API Gateway instance(s). For the new instance(s) to take the new data, it (they) need to be restarted. Invoke the below REST API to restart the API Gateway instance(s).

`POST /rest/apigateway/shutdown`

```json
{
    "bounce": true,
    "option": "force"
}
```

> Note: For a cluster this should be done in all instances.

#### Rollback on error

If the restart of new instances fails, stop proceeding with the next steps and disable the Quiesce mode for design time in all the nodes and bring them back to normal state. Contact Software AG support team for help with all the relevant logs for further analysis.

### Step 7: Add traffic to new API Gateway instance(s)

After the new API Gateway instance(s) is restarted, now the runtime traffic can be allowed to it. Adding traffic to the new instance(s) depends on the deployment model.

For e.g for on-premise and docker deployment, it would be an update to load balancer for adding the new endpoints. For kubernetes deployment, it would be a label change in Service resources.

### Step 8: Put old API Gateway instance(s) into Quiesce mode for all

> **Note**: This operation is performed at old API Gateway instance. For a cluster, do this at each node as Quiesce mode is performed at instance level.

At this time, the runtime traffic is flowing to both old and new API Gateway instances. Now we need to stop the traffic to old instance(s) and allow the traffic to be sent only to the new instance(s). But while stopping the old instance(s), there may be ongoing requests in the old instance(s) which are still in progress which we can't loss. Moreover all the in-memory data like performance metrics, license metrics and subscription quota should be stored in the datastore before runtime data is getting migrated. This will be achieved by putting the old instance(s) into Quiesce mode for all.

#### Prerequisite

Before invoking Quiesce mode for all, as a prerequisite, Quiesce port should be created and enabled in old API Gateway. Invoke the below APIs to create and enable the Quiesce port.

Invoke the below API to create the port. In this example we used 4444 as the port number.

`POST /rest/apigateway/ports`

```
{
    "factoryKey": "webMethods/HTTP",
    "pkg": "WmRoot",
    "port": "4444",
    "portAlias": "QuiescePort"
}
```

Invoke the below API to enable the port.

`PUT rest/apigateway/ports/enable`

```
{
    "listenerKey": "HTTPListener@4444",
    "pkg": "WmRoot",
    "requestServiceStatus": ""
}
```

Invoke the below API to set the Quiesce port. Given the same *portAlias* value used in the port creation API.

`PUT invoke/wm.server.quiesce/setQuiescePort`

```
{
    "portAlias": "QuiescePort"
}
```

Now the Quiesce port is created and enabled.

#### Enabling Quiesce mode for all

Invoke the below REST API to put the old instance(s) to Quiesce mode for all.

`PUT /rest/apigateway/quiescemode`

```json
{
    "block": "all",
    "flush": [
        "license_metrics",
        "performance_metrics",
        "subscription_quota"
    ],
    "enable": true
}
```

> **Note**: For a cluster, the above API should be invoked for each instance one after another as Quiesce mode is performed at instance level. Once a node is entered into Quiesce mode for all, the API can be invoked on the next node. Make sure the API is not simultaneously invoked on all the nodes at time.

#### Quiesce mode for all operation status

Since this is a long operation, the REST API will initiate the action and return with 200 OK, if the invocation is successful.

When the Quiesce mode for all is complete, API Gateway sends out a notification with the result details through registered webhooks. Suppose if you are interested in retrieving the status through API, invoke the below REST API through **Quiesce port** to check if the Quiesce mode for all is completed.

`GET /rest/apigateway/health`

If status code returned is 200 OK, that means the Quiesce mode for all is still in progress. When the request started returning anything other that 200 or no http response, then it can be considered that Quiesce mode for all is completed successfully.

> **Note**: For a cluster, the above API should be invoked for each instance to get the Quiesce mode status of that instance. In case of webhooks, each instance will send a notification after complete.

#### Rollback on error

If the Quiesce mode for all API invocation fails with an error or the status returned with a failure, stop proceeding with the next steps and disable the Quiesce mode for design time in all the nodes and bring them back to normal state. If the instances were already entered into Quiesce mode, restart all the instances and update the load balancer to route the traffic only to it/them to go back to the original state before migration. Contact Software AG support team for help with all the relevant logs for further analysis.

### Step 9: Migrate logs and events data

> **Note**: This operation is performed at new API Gateway instance. For a cluster, do this in one of the nodes.

After Quiesce mode for all is complete in old API Gateway instance(s), now the logs and events data can be migrated to the new instance(s). Invoke the below REST API at the new API Gateway instance to migrate the data. 

`POST /rest/apigateway/migration`

```json
{
    "action": "reindex",
    "indicesType": "logsevents",
    "sourceElasticsearch": {
        "url": "http://localhost:9200",
        "username": "username",
        "password": "password"
    },
    "properties": {
    	"apigateway.migration.srcTenantName": "apigateway",
        "apigateway.migration.batchSize": 100,
        "apigateway.migration.logLevel": "info",
        "apigateway.migration.reindex.status.check.sleep.interval": 5000,
        "apigateway.migration.batchSize.gateway_{0}_apis": 50,
        "apigateway.migration.batchSize.gateway_{0}_log": 100,
        "apigateway.migration.batchSize.gateway_{0}_audit_auditlogs": 50,
        "apigateway.migration.batchSize.gateway_{0}_analytics_transactionalevents": 50
    }
}
```

The status of this migration action can be checked similar to design time data migration.

After this, the runtime data will be added to the existing runtime data. The upgrade is complete with this step.

#### Rollback on error

If the reindex API invocation for logs and event data fails with an error or the status returned with a failure, follow one of the two options. At first, try to troubleshoot the problem by looking at the logs. If no success, reindex the logs and events indices manually using the Elasticsearch reindex API. If the issue is not solved, contact Software AG support team for help with all the relevant logs for further analysis.

> **Note**: These are the logs and events indices in the datastore. gateway_tenantId_quotaAccumulator, gateway_tenantId_analytics_performanceMetrics, gateway_tenantId_analytics_threatProtectionEvents, gateway_tenantId_analytics_lifecycleEvents, gateway_tenantId_analytics_errorEvents, gateway_tenantId_analytics_transactionalEvents, gateway_tenantId_analytics_policyViolationEvents, gateway_tenantId_analytics_monitorEvents, gateway_tenantId_license_licenseMetrics, gateway_tenantId_license_notifications, gateway_tenantId_log and gateway_tenantId_audit_auditlogs.

### Step 10: Shutdown old API Gateway instance(s)

If migration is successful and the new API Gateway nodes are stable, shutdown the old nodes so that they won't send any metrics to any configured destinations like API Portal, external Elasticsearch, etc. The new instance(s) is now receiving the runtime transactions. You can probably remove the old instance(s) endpoint(s) from the load balancer.

## Troubleshooting

For seeing the detailed logs during the upgrade process, enable the debug logs for these logging facilities 0300 Gateway Commons and 0205 MEN - Events. For the step by step progress on the migration actions (clean and reindex) please refer the logs at SAG_Install/profiles/IS_default/logs/wrapper.log.
