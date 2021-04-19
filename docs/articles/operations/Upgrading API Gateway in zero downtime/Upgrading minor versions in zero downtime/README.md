# Upgrading minor versions in zero downtime

Supported versions: 

10.7 or above

## Overview of the tutorial

This tutorial explains in detail the steps needed for upgrading API Gateway in zero downtime for minor versions, i.e. Fix updates, like 10.7 Fix 1 to 10.7 Fix 2. The upgrade details for cluster and standalone deployments are explained in separate sections.

## Required knowledge

The tutorial assumes that the reader has,

*   a basic knowledge on the API Gateway as a product

## Why?

The existing migration approach incurs a downtime while doing upgrade. This approach provides an upgrade process with zero downtime.

## Prerequisite steps

Complete the below prerequisites to make you ready to get into the details of upgrading API Gateway in zero downtime.

*   Old API Gateway instance should be running

## Details

### Upgrade of cluster deployment

Zero downtime upgrade of minor versions in a cluster is a rolling upgrade. Old nodes are brought down and come out of the cluster one by one while new nodes are brought up and added to the cluster one by one. In this section we will go through the steps.

The below diagram show the entire workflow for this use case.

![](attachments/Workflow-cluster.jpg)

The steps are given below.

#### Step 1: Shutdown one of old API Gateway nodes

> **Note**: If all the nodes in the cluster are new nodes, then skip this step as migration is complete.

Shutdown one of the old nodes after all the active client sessions in that node are closed.

Invoke the below REST API to shutdown the old instance(s).

`POST /invoke/wm.server.admin/shutdown`

```json
{
    "bounce": "no",
    "option": "drain",
    "timeout": 10
}
```

The timeout value is depending on the number of active client sessions.

> **Note**: For 10.7 and above use the API Gateway API /rest/apigateway/shutdown to shutdown the API Gateway server.

##### Rollback on error

If the shutdown fails with error, restart all the instances and update the load balancer to route the traffic only to it/them to go back to the original state before migration. Contact Software AG support team for help with all the relevant logs for further analysis.

#### Step 2: Apply fix and start

When the node in Step 1 is shutdown, apply the fix and start again.

> **Note**: For Docker case the fix can't be applied on the old container. Instead a new container from an image already built with the fix is started. Make sure the IS configurations which are not stored in datastore and custom IS packages are pre-configured in the new containers when starting.

Repeat Steps 1 and 2 until all the nodes in the cluster becomes new nodes.

### Upgrade of standalone deployment

In this section we will go through the steps for doing zero downtime upgrade of minor version in a standalone deployment.  The below diagram shows the entire workflow for this use case.

![](attachments/Workflow-standalone.jpg)

The steps are given below.

#### Step 1: Start new API Gateway instance

Install the new API Gateway instance, apply the desired fix and do the below prerequisites.

##### IS/File system configurations and custom packages

As zero downtime upgrade dealt only with the migration of datastore data, the Administrator has to take care of migrating the non datastore configurations such as file system configurations, ports configurations and custom ESB packages to the new API Gateway instance(s) before running the migration of data. For a detailed list of configurations that are to be manually configured by the Administrator, please refer *Backup and Restore* section under *Data Management* chapter in the *API Gateway Configuration Guide*. 

###### File system configurations

The configurations are listed below for your convenience.

| Configuration                      | File name                                                    | File location                                                |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Elasticsearch configuration        | elasticsearch.yml                                            | SAGInstallDir/InternalDataStore/config/                      |
| Elasticsearch client configuration | config.properties                                            | SAGInstallDir/IntegrationServer/instances/<br/>instance_name/packages/WmAPIGateway/config/<br/>resources/elasticsearch/ |
| Kibana configuration               | kibana.yml                                                   | SAGInstallDir/profiles/instance_name/<br/>apigateway/dashboard/config/ |
| Master password                    | mpw.dat                                                      | SAGInstallDir/profiles/instance_name/<br/>configuration/security/passman/ |
| UI configurations                  | uiconfiguration.properties                                   | SAGInstallDir/profiles/instance_name/<br/>apigateway/config/ |
| SAML group mapping                 | saml_groups_mapping.xml                                      | SAGInstallDir/IntegrationServer/instances/<br/>instance_name/packages/WmAPIGateway/config/<br/>resources/security/ |
| WebApp settings                    | com.softwareag.catalina.connector.http.pid-apigateway.properties<br/>com.softwareag.catalina.connector.https.pid-apigateway.properties | SAGInstallDir/profiles/instance_name/<br/>configuration/<br/>com.softwareag.platform.config.propsloader/ |

###### Server ports configuration

If the portClusteringEnabled extended setting is set to false, the server ports should be created in each instance by the Administrator.

###### Custom ESB packages

Also make sure that all the custom packages are installed and ready in the new instance(s).

Now start the new API Gateway instance by connecting it to the old datastore as external.

#### Step 2: Put old API Gateway instance into Quiesce mode for design time

> **Note**: This operation is performed at old API Gateway instance.

API Gateway data in the datastore is migrated in two phases. In first phase, only the design time data like APIs, Applications, Policies, etc. will be migrated. The runtime data like audit logs, transaction logs, performance metrics, etc. will be migrated in the next phase that is after the runtime transactions to the old instance(s) are stopped. This will be done after the new instance(s) is up and running with the new data and runtime traffic is allowed to it.

Before migrating design time data in the first phase, all the updates to them through UI and REST APIs need to be blocked. This can be achieved by the Quiesce mode capability available in API Gateway.

Invoke the below REST API at old API Gateway instance to put it into Quiesce mode for design time.

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

Now all the design time invocations to the old instance will be blocked and API Gateway will return 503 to the client. Only the below requests will be allowed:

- All GET requests
- /rest/apigateway/quiescemode
- /rest/apigateway/search
- /rest/facade/apigateway/searchApis

##### Quiesce mode for design time operation status

When the Quiesce mode for design time is complete, API Gateway sends out a notification through webhook with the result details if a one is registered. Or you can invoke the below REST API to check for the current status of the operation.

`GET rest/apigateway/quiescemode`

`"status": "success"` means the Quiesce mode for design time is complete.

##### Rollback on error

If the Quiesce mode for design time API invocation fails with an error or the status returned with a failure, stop proceeding with the next steps and disable the Quiesce mode for design time in the old node and bring it back to normal state. Contact Software AG support team for help with all the relevant logs for further analysis.

#### Step 3: Add traffic to new API Gateway instance

After the new API Gateway instance is started, now the runtime traffic can be allowed to it. Adding traffic to the new instance depends on the deployment model.

For e.g for on-premise and docker deployment, it would be an update to load balancer for adding the new endpoints. For kubernetes deployment, it would be a label change in Service resources.

#### Step 4: Put old API Gateway instance into Quiesce mode for all

> **Note**: This operation is performed at old API Gateway instance.

At this time, the runtime traffic is flowing to both old and new API Gateway instances. Now we need to stop the traffic to old instance and allow the traffic to be sent only to the new instance. But while stopping the old instance, there may be ongoing requests in the old instance which are still in progress which we can't loss. Moreover all the in-memory data like performance metrics, license metrics and subscription quota should be stored in the datastore before runtime data is getting migrated. This will be achieved by putting the old instance into Quiesce mode for all.

##### Prerequisite

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

Invoke the below API to set the Quiesce port. Given the same portAlias value used in the port creation API.

`PUT invoke/wm.server.quiesce/setQuiescePort`

```
{
    "portAlias": "QuiescePort"
}
```

Now the Quiesce port is created and enabled.

##### Enabling Quiesce mode for all

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

##### Quiesce mode for all operation status

Since this is a long operation, the REST API will initiate the action and return with 200 OK, if the invocation is successful.

When the Quiesce mode for all is complete, API Gateway sends out a notification through webhook with the result details if a one is registered. Suppose if you are interested in retrieving the status through API, invoke the below REST API through **Quiesce port** to check if the Quiesce mode for all is completed.

`GET /rest/apigateway/health`

If status code returned is 200 OK, that means the Quiesce mode for all is still in progress. When the request started returning anything other that 200 or no http response, then it can be considered that Quiesce mode for all is completed successfully.

##### Rollback on error

If the Quiesce mode for all API invocation fails with an error or the status returned with a failure, stop proceeding with the next steps and disable the Quiesce mode for design time in all the nodes and bring them back to normal state. If the instances were already entered into Quiesce mode, restart all the instances and update the load balancer to route the traffic only to it/them to go back to the original state before migration. Contact Software AG support team for help with all the relevant logs for further analysis.

#### Step 5: Shutdown old API Gateway instance

When Quiesce mode for all completed successfully in the old instance, shutdown it so that it won't send any metrics to any configured destinations like API Portal, external Elasticsearch, etc. The new instance is now receiving the runtime transactions. You can probably remove the old instance endpoint from the load balancer.
