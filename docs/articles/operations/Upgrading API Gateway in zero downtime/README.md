# Upgrading API Gateway in zero downtime

## Introduction

API Gateway follows Blue-Green deployment approach to upgrade to newer version in zero downtime. In such deployment scenario, old instance will be allowed to run and serve the transactions while the new version of API Gateway is being prepared with data migration. The data migration happens in two phases. In the first phase, the old instance is blocked for design time(core) data updates and all the design time(core) data would be migrated to the new datastore, while the new API Gateway version is running. Next the new version is restarted with the migrated design time data and the endpoint is added to the load balancer. At this time the transactions are served by both the old and new versions. In the second phase, all the transactions to the old version is blocked and the logs and events data are migrated to the new version while it is serving the transactions.

In zero downtime upgrade, API Gateway takes care of migrating only the datastore data and all the file system configurations and custom IS packages would be taken care by the Administrators.

## Capabilities needed for upgrade

This section explains the following capabilities needed for upgrading API Gateway in zero downtime.

- API Gateway Quiesce mode
- Migration REST APIs
- Webhook notifications
- Shutdown REST API

### 1. API Gateway Quiesce mode

> **Note**: This operation is performed at the older version of API Gateway.

Quiescing API Gateway temporarily disables access to the server so you can perform the required tasks while the server is not connected to any external resources. In API Gateway the quiesce mode is used during the zero downtime upgrade wherein the access to the server is temporarily disabled, so you can perform the upgrade tasks. 

API Gateway supports the following two types of quiesce mode.

#### Type 1: Blocks only design time requests.

In this mode API Gateway server blocks all design time requests such as all the CRUD operations for API Gateway assets like APIs, policies, applications, and so on, and returns an appropriate status code (503) to the client.

#### Type 2: Blocks all requests

In this mode API Gateway becomes unreachable for all the requests, design time and runtime. Any requests that are already in progress are permitted to finish, but any new inbound requests to the server are blocked. This mode is an extension of the Integration Server quiesce mode, where API Gateway flushes the Quota, performance, and transaction license metrics data to the datastore before the API Gateway package is disabled. 

While flushing the performance, license, and quota metrics data, API Gateway performs the following operations:

- Resets performance and license metrics intervals for all the APIs and immediately stores the data into the datastore.
- Immediately stores the Subscription quota into the datastore. 

When all the performance metrics and other data are flushed completely, a notification mentioning that quiesce mode for all is enabled is sent through a webhook event.

#### Enabling and disabling Quiesce mode

The following API helps to enable or disable quiesce mode.

`PUT /rest/apigateway/quiescemode`

```json
{
    "enable": "true/false",
    "block": "designtime/all",
    "flush": [
        "license_metrics",
        "performance_metrics",
        "subscription_quota"
    ]
}
```

| Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| enable    | Set the enable parameter as true to enable quiesce mode and false to disable the quiesce mode. Disabling is supported only when the block parameter is set as designtime. When the block parameter is set as all, API Gateway is quiesced and is unreachable. Hence, you cannot disable the API Gateway quiesce mode by invoking this API. |
| block     | Set the block parameter as designtime to block only design time requests and all to block all requests. |
| flush     | The flush parameter is not applicable when you set the block parameter as designtime. The flush parameter is applicable when you set the block parameter as all. In the above example, when you set the block parameter as all, API Gateway blocks all the requests and flushes the license metrics, performance metrics, and subscription quota data. If you do not specify anything for the flush parameter, then all the data are flushed. |

#### Retrieving Quiesce mode status

In addition to the webhook notification of the Quiesce mode status, API Gateway provides the following API to retrieve the status of the quiesce mode.

> **Note**: This works only for Quiesce mode for designtime. For all this will not work as the API Gateway package would be disabled when Quiesce mode for all is invoked. In such case invoke the API Gateway health check API through Quiesce port. If that returns a status code other than 200 or no response then it can be considered that the Quiesce mode for all is completed in that node successfully.

`GET /rest/apigateway/quiescemode`

###### Response

```json
{
    "enable": "true/false",
    "block": "designtime/all",
    "flush": [
        "license_metrics",
        "performance_metrics",
        "subscription_quota"
    ],
    "status": "success",
    "failureReason": null
}
```

#### Create Quiesce port as a prerequisite

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

### 2. Migration REST APIs

> **Note**: These operations are performed at the newer version of API Gateway.

These APIs trigger a migration action and immediately returns a 202 status code. When the action is completed a webhook event with the migration status would be sent to the subscribed webhook clients.

#### Clean datastore

The clean action deletes the data from the datastore. This should be invoked prior to invoking the reindex API for core indices. 

> **Note**: For a safety measure, by default this action would take a backup prior to deleting the data. Hence as a prerequisite, `path.repo` property should be configured in the *elasticsearch.yml* file for the datastore to take a snapshot in that location. If the Administrator deliberately wants to exclude the backup of data then add `"backup": false` in the payload.

`POST /rest/apigateway/migration`

```json
{
    "action": "clean"
}
```

#### Reindex datastore

The reindex action re-indexes the data from the old API Gateway's datastore to new API Gateway's datastore.

> **Note**: As a prerequisite. remote datastore host has to be explicitly allowed in elasticsearch.yml using the `reindex.remote.whitelist` property. Configure `reindex.remote.whitelist` in *SAG/InternalDataStore/config/elasticsearch.yml* file and set the value of old API Gateway's datastore host and port like `reindex.remote.whitelist: localhost:9200`. 

`POST /rest/apigateway/migration`

```json
{
    "action": "reindex",
    "indicesType": "core/logsevents",
    "sourceElasticsearch": {
        "url": "http://remotehost:9240",
        "username": "username",
        "password": "password"
    },
    "properties": {
        "apigateway.migration.srcTenantName": "default",
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

| Parameter           | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| indicesType         | Specifies the type of indices to be reindexed from old ES to new ES. Possible values are core and logsevents. Core indices are the ones that are used to store the design time assets like APIs, Alias, Configurations, etc. logsevents indices are the ones used to store the logs and events like performance metrics, license metrics and logs. |
| sourceElasticsearch | The old API Gateway's datastore details.                     |
| properties          | These migration properties can be used to specify the old API Gateway's tenant name and optimize the performance of reindex action. If not specified, the values from this file SAG\IntegrationServer\instances\default\packages\WmAPIGateway\bin\migrate\migration.properties will be taken. |

#### Transform datastore

The transform action transforms the re-indexed assets in the new API Gateway's datastore to be compatible with the new API Gateway version.

`POST /rest/apigateway/migration`

```json
{
    "action": "transform"
}
```

#### Migration action status

This API retrieves the current status of the migration action which is invoked in API Gateway.

`GET /rest/apigateway/migration/status?action=[reindex | transform | clean]`

```json
{
    "status": "success",
    "failureReason": null
}
```

### 3. Webhook notifications

> **Note**: This operation can be performed at both older and newer versions of API Gateway.

When Quiesce mode or a migration action is completed, a webhook event with the status would be sent to the subscribed webhook clients. 

The following events are supported.

| Webhook event                          | Action                                                       |
| :------------------------------------- | :----------------------------------------------------------- |
| apigateway:server:started              | This event will be fired after API Gateway server is up.     |
| migration:clean:datastore:completed    | This event will be fired after clean action will be completed. |
| migration:quiesce:all:completed        | This event will be fired after Quiesce mode for all requests will be completed. |
| migration:quiesce:designtime:completed | This event will be fired after Quiesce mode for design time requests will be completed. |
| migration:reindex:core:completed       | This event will be fired after reindexing of core ES indices will be finished. |
| migration:reindex:logsevents:completed | This event will be fired after reindexing of logs and events ES indices will be finished. |
| migration:transform:assets:competed    | This event will be fired after all the migration handlers for asset transformation will be finished running. |

The following REST APIs help to do the CRUD of webhooks in API Gateway.

#### Create webhook

`POST /rest/apigateway/wehooks`

```json
{
    "config": {
        "url": "http://apigatewaymig.free.beeceptor.com/my/api/path/test",
        "headers": {"type": "core"},
        "username": null,
        "password": null,
        "truststoreAlias": null
    },
    "events": [
        "migration:reindex:core:completed"
    ],
    "active": true
}
```

| Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| config    | Specifies webhook client endpoint configuration details like url, headers, etc |
| events    | The list of interested events the webhook is subscribed for. |
| active    | Specifies whether this webhook is active or not. Default value is false. |

#### Update webhook

`PUT /rest/apigateway/wehooks/{id}`

```json
{
    "config": {
        "url": "http://apigatewaymig.free.beeceptor.com/my/api/path/test",
        "headers": {"type": "core"},
        "username": null,
        "password": null,
        "truststoreAlias": null
    },
    "events": [
        "migration:reindex:core:completed"
    ],
    "active": true
}
```

#### Retrieve webhook

This retrieves the webhook for the specified id.

`GET /rest/apigateway/wehooks/{id}`

This retrieves all the webhooks in the system.

`GET /rest/apigateway/wehooks`

#### Delete webhook

This deletes the webhook for the specified id.

`DELETE /rest/apigateway/wehooks/{id}`

### 3. Shutdown REST API

> **Note**: This operation is performed at both older and newer versions of API Gateway.

API Gateway provides API to shutdown the server. 

`POST /rest/apigateway/shutdown`

```json
{
    "bounce": "true/false",
    "option": "force/drain",
    "timeout": 10,
    "quiesce": "true/false"
}
```

| Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| option    | Specifies whether to shutdown API Gateway server immediately or after all client sessions are ended. A value of 'force' would shutdown the server immediately and 'drain' would wait for a maximum period of time for all the client sessions to end before shutdown. |
| timeout   | Specifies the maximum wait time in minutes before API Gateway server is shutdown when option drain is specified. |
| bounce    | Specifies whether to restart API Gateway server after shutdown. A value of true would restart the server. Default value is false. |
| quiesce   | A value of true would first flush the API Gateway in memory data like performance metrics, license metrics and subscription quota to datastore before shutdown of the server. Next, when API Gateway is restarted either manually or using bounce parameter, the Integration server will be started in Quiesce mode. Note: In a cluster, the flushing of in memory data would happen only on one of the nodes and hence on other nodes the API call would return immediately by eliminating the flush time. The default value is false. |

## Learn more

- For details on upgrading major versions, refer **[this](Upgrading%20major%20versions%20in%20zero%20downtime/)** article

- For details on upgrading minor versions, refer **[this](Upgrading%20minor%20versions%20in%20zero%20downtime/)** article
