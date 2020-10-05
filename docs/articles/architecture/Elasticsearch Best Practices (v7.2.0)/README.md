Elasticsearch Best Practices (v7.2.0)
==========================================================
Author: Rizwan, Mohammed (mriz@softwareag.com)<br>
Supported Versions: 10.5

Purpose
-------

API Gateway uses [Elasticsearch](https://www.elastic.co/products/elasticsearch) as its primary data store for persisting different types of data like APIs, Policies, Applications etc. apart from runtime events and metrics. This document is intended to provide some basic guidelines for configuring and managing Elasticsearch. At different points in the document, we will provide the configurations/tunings details vis-a-vis API Gateway. Please note, though the information provided in this document would enable to you get started with the basic configurations, it is important that you refer to the official Elasticsearch documentation for completeness. 

Elasticsearch Basics
--------------------

**Document**

A document is a JSON document which is stored in Elasticsearch. It is like a row in a table in a relational database. Each document is stored in an [index](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-index) and has a [type](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-type) and an [id](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-id).

A document is a JSON object (also known in other languages as a hash / hashmap / associative array) which contains zero or more [fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-field), or key-value pairs.

The original JSON document that is indexed will be stored in the [`_source` field](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-source_field), which is returned by default when getting or searching for a document.

**Type**

A type used to represent the _type_ of document, e.g. an `email`, a `user`, or a `tweet`. Types are deprecated and are in the process of being removed

**Index**

An index is like a _table_ in a relational database. It has a [mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-mapping) which contains a [type](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-type), which contains the [fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-field) in the index.

An index is a logical namespace which maps to one or more [primary shards](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-primary-shard) and can have zero or more [replica shards](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-replica-shard).

**Shard**

A shard is a single Lucene instance. It is a low-level “worker” unit which is managed automatically by Elasticsearch. An index is a logical namespace which points to [primary](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-primary-shard) and [replica](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-replica-shard) shards.

Other than defining the number of primary and replica shards that an index should have, you never need to refer to shards directly. Instead, your code should deal only with an index.

Elasticsearch distributes shards amongst all [nodes](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-node) in the [cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-cluster), and can move shards automatically from one node to another in the case of node failure, or the addition of new nodes.

**Primary Shard**

Each document is stored in a single primary [shard](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-shard). When you index a document, it is indexed first on the primary shard, then on all [replicas](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-replica-shard) of the primary shard.

By default, an [index](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-index) has one primary shard. You can specify more primary shards to scale the number of [documents](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-document) that your index can handle.

You cannot change the number of primary shards in an index, once the index is created. However, an index can be split into a new index using the [split API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-split-index.html "Split index API").

**Replica Shard**

Each [primary shard](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-primary-shard) can have zero or more replicas. A replica is a copy of the primary shard, and has two purposes:

1.  increase failover: a replica shard can be promoted to a primary shard if the primary fails
2.  increase performance: get and search requests can be handled by primary or replica shards.
    
    By default, each primary shard has one replica, but the number of replicas can be changed dynamically on an existing index. A replica shard will never be started on the same node as its primary shard.
    

**Nodes**

A node is a running instance of Elasticsearch which belongs to a [cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#glossary-cluster). Multiple nodes can be started on a single server for testing purposes, but usually you should have one node per server.

At startup, a node will use unicast to discover an existing cluster with the same cluster name and will try to join that cluster. There are many of nodes but the 2 most important types are

*   **Master Node :** 
    *   The master node is responsible for lightweight cluster-wide actions such as creating or deleting an index, tracking which nodes are part of the cluster, and deciding which shards to allocate to which nodes. It is important for cluster health to have a stable master node.
    *   A node that has `node.master` set to `true` (default), which makes it eligible to be [elected as the _master_ node](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery.html "Discovery and cluster formation"), which controls the cluster.  
    
*   **Data Node :** 
    *   Data nodes hold the shards that contain the documents you have indexed. Data nodes handle data related operations like CRUD, search, and aggregations. These operations are I/O-, memory-, and CPU-intensive. It is important to monitor these resources and to add more data nodes if they are overloaded.  
        
    *   A node that has `node.data` set to `true` (default). Data nodes hold data and perform data related operations such as CRUD, search, and aggregations.  
        

**Read / Write Semantics**

For a write( update , delete ), the request will be routed to primary shared. The primary validates the data, writes the changes and replicate the same to other shards. Once all replication is done successfully, the ack is sent back to caller.

For a read, the request is sent to all nodes which could serve the requests in "scatter" phase. the result is consolidated in "gather" phase and sent back to caller. if there are more replica, the request will be sent by round robin.

Refer **[read/write](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-replication.html#_basic_read_model)** model for more details.

Data Types
----------

API Gateway data can be broadly classified into 4 types

1.  Core Configurations
    - This includes APIs, Applications, Policies, Plans, Packages, Administration Settings, Security Configurations (Keystores/Trustores) & Tokens (OAuth/API Keys). This data, by default, is stored in Elasticsearch embedded in API Gateway (as InternalDataStore).
2.  Runtime Transactions
    - This includes the runtime transactions events and metrics data. By default API Gateway stores this data in Elasticsearch (InternalDataStore) but this can modified so that API Gateway can emit this data to other destinations (like external Elasticsearch, RDBMS, DES etc). 
    
3.  Application Logs (from 10.3)
    
    - API Providers can configure the application logs to be stored in Elasticsearch (InternalDataStore) but this can be modified. Refer to the product documentation for more details.
4.  Audit Logs (from 10.2)
    - API Gateway, by default, stores the audit logs in Elasticsearch (InternalDataStore) but this can be modified. Refer to the product documentation for more details.

### Separation of Data

It is possible to separate the Core Configuration store from the other data store (such as Runtime transactions, Application Logs, Audit Logs). And it may be a good practice cases where there is large volume of runtime transactions data and you want to scale the Elasticsearch used for runtime transactions independent of the default store.  This is possible because API Gateway provides options for the API providers to configure external destinations to which API Gateway can emit the data such as Runtime transactions, Application Logs, Audit Logs. Refer to the product documentation to configure the external destination store. 

Elasticsearch Configurations
----------------------------

### Using External Elastic Search

API Gateway installation bundles a default Elasticsearch (IntenalDataStore) and all the data by default is written to this Elasticsearch. But the user can configure the API Gateway to use external Elasticsearch .  

> **Note:**
>
> 10.1 or lower versions of API Gateway can only be configured with 2.3.2 version of Elasticsearch. Starting 10.2 version of API Gateway, you can configure a wide range of Elasticsearch versions.  
> Starting 10.5 version of API Gateway, it will work only with open source ES i.e Elasticsearch OSS

Following table shows the Elasticsearch support matrix for API Gateway.

| API Gateway | Elasticsearch        | Comments                                                     |
| :---------- | :------------------- | :----------------------------------------------------------- |
| 9.12        | 2.3.2                |                                                              |
| 10.0        | 2.3.2                |                                                              |
| 10.1        | 2.3.2                |                                                              |
| 10.2        | >=2.3.2 and <= 5.6.4 | InternalDataStore is 5.6.4 but API Gateway can work with versions below 5.6.4 |
| 10.3        | >=2.3.2 and <= 5.6.4 | InternalDataStore is 5.6.4 but API Gateway can work with versions below 5.6.4 |
| 10.4        | >=2.3.2 and <= 5.6.4 | InternalDataStore is 5.6.4 but API Gateway can work with versions below 5.6.4 |
| 10.5        | 7.2.0                | API Gateway is certified to work with 7.2.0                  |

For 10.1, please refer to this [article](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configuring+External+Elasticsearch+for+API+Gateway+10.1).

For 10.2 & 10.3, please refer to product documentation, API Gateway Configuration Guide or [Configuring External Elasticsearch for API Gateway 10.2](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configuring+External+Elasticsearch+for+API+Gateway+10.2).

### Elasticsearch HTTP Client Configurations

API Gateway provides options for you to control the way that API Gateway will talk to the Elasticsearch. Refer to product document, API Gateway Configuration Guide, to get more details on the same.

### Elasticsearch server Configurations

API Gateway defaults to the Elasticsearch default configurations for its InternalDataStore. The default Elasticsearch configurations are generally good for starters. Following are the default configurations that you can find in InternalDataStore\\config\\elasticsearch.yml

###### Default Configuration

```
cluster.name: SAG\_EventDataStore`
node.name: XXXXX1540445984673
path.logs: C:\\APIGW\\InternalDataStore/logs
network.host: 0.0.0.0

http.port: 9240

discovery.seed\_hosts: \["localhost:9340"\]
transport.tcp.port: 9340
path.repo: \['C:\\APIGW\\InternalDataStore/archives'\]

cluster.initial\_master\_nodes: \["XXXXX1540445984673"\]
```

> **Important Recommendations**
>
> - path.repo is a mandatory configuration for performing backup and restore. It should be network file system or S3 in clustered setup
>
> - For a production setup,  you may have to change the defaults especially the cluster, networking, logging and data configurations. This document does not give you all the details on the configurations. You can refer to [https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html).
>
> - It is important that you run through the configurations mentioned at [https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html)
>
> - Detailed configurations can be looked up at [https://www.elastic.co/guide/en/elasticsearch/reference/current/modules.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules.html)
>

#### Data location

Elasticsearch provide option for you to configure the locations where you would want your data and logs to be stored. You should make sure that you specify the locations that are accessible and will have enough disk space.  It is also important to monitor and ensure basic house keeping of the data location by plan an effective data retention strategy. Following configuration lets you change the defaults - [https://www.elastic.co/guide/en/elasticsearch/reference/current/path-settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/path-settings.html) 

###### **Data location**

```
path.data: /var/lib/elasticsearch
path.logs: <IS\_Installed\_Location>/InternalDataStore/logs
// These values can be changed
```

#### Network 

Elasticsearch, by default, binds to loop back address. It is important to change that for production deployment.  [https://www.elastic.co/guide/en/elasticsearch/reference/current/network.host.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/network.host.html) 

#### Refresh interval

The operation that consists of making changes visible to search - called a [refresh](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html "Refresh API") - is costly, and calling it often while there is ongoing indexing activity can hurt indexing speed.  
In case of very high volume transactions (e.g. 50 TPS / 5 million transactions per day), it is recommend to set the refresh interval of indices like transaction events to a higher value.

PUT http://server:port/gateway\_default\_analytics\_transactionalevents/\_settings

```
{
  "index" : {
    "refresh\_interval" : "60s"
  }
}
```

#### Dynamic field mapping

Typically the field mappings of an index are predefined. However Elasticsearch does not stop you from adding new fields to the index at runtime. Elasticsearch can automatically create mapping for such fields even though they are not predefined in the index field mapping. This flexibility enables the user to search on such dynamically added fields. However it can lead to "mapping explosion" where we end up with way too many field mappings defined for an index. This in turn will create significant memory and performance issues.

To avoid the mapping explosions, for those indices where we expect many dynamic fields, it is recommended to set the "dynamic" attribute of an index mappings to false. For such indices, if you update the "dynamic" property to "true", it will result in mapping explosion.

Updating the dynamic property for an index :
```
PUT index_name/_mappings
{
   "mappings" : {
       "dynamic" : false,
        ...
        static field mapping definitions
        ...
    }
}
```

### Elasticsearch Log Configurations

Elasticsearch uses log4j 2 for logging. Log4j 2 can be configured using the log4j2.properties file which is located in <IS\_Installed\_Location/InternalDataStore/config/log4j2.properties.

By default, API Gateway logs the action execution errors for easier debugging with the below snippet

```
logger.action.name = org.elasticsearch.action
logger.action.level = debug
```

For example, if you have an issue with nodes joining/leaving the cluster, or with master election, org.elasticsearch.discovery.zen would be the package to monitor in your logs as below  

PUT /\_cluster/settings

```
{"transient": {"logger.discovery.zen":"TRACE"}}
```

You can set the fine-grained level logger with the below template by replacing the name of logging hierarchy with the java package

```
logger.<unique\_identifier>.name = <name of logging hierarchy>
logger.<unique\_identifier>.level = error
```

You can find the list of logging hierarchy [here](https://javadoc.io/doc/org.elasticsearch/elasticsearch/7.2.0/index.html) which starts with org.elasticsearch

You can find more details about log4j 2 properties [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/logging.html) and few good examples provided [here](https://www.elastic.co/blog/elasticsearch-logging-secrets)

### Sizing Strategy

Allocation for disk space for Elasticsearch will depend on the volume of data that you plan to store. Generally the Core Configurations (explained in the Data Types section above) does not have scope to grow in runtime (except for consumer applications & security tokens) and hence your initial sizing should depend on the number of APIs, configured policies, estimated number of applications/subscriptions & estimated number of security tokens. 

The Runtime Transactions data has a potential to grow big. Runtime transactions and metrics are stored when Logging and Monitoring policies are enabled.  You can base your sizing strategy based on the following parameters

*   Transactions per second
*   Average size of the payload (request + response)
*   Data Retention strategy (purging interval)

The size of Application logs and Audit logs purely depend on your log configurations. You have to make a best judgement here. You can configure an external elastic search to store the application logs, audit logs and runtime transactions and metrics data. You can refer API Gateway documentation on how to part and also refer [http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configuring%20External%20Elasticsearch%20for%20API%20Gateway%2010.2](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configuring%20External%20Elasticsearch%20for%20API%20Gateway%2010.2) for required kibana changes.

The disk space allocation for all the above will also depend on your sharding and replication strategy (see below) as enabling these will distribute your data across different Elasticsearch nodes. 

Please refer horizontal scale up section, when the data volume is growing.

### Sharding & Replication

API Gateway, by default, provides a optimum shard allocation for each index and it is not recommended to change them. 

For replication, the general recommendation for a production cluster is to have 2 replicas per shard for handling failover. 

API Gateway ships 7 categories of indices by default. They are 

| Default Index                                                | Description                                                  | Alias                                                        |
| ------------------------------------------------------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| gateway_default_<Gateway_Asset_Type>                         | store for Core Configurations - 1 index for one each type of gateway asset |                                                              |
| gateway_default_analytics_<Analytics_Event_Type>_000001<br>gateway_default_analytics_policyviolationevents-000001<br>gateway_default_analytics_threatprotectionevents-000001<br/>gateway_default_analytics_lifecycleevents-000001<br/>gateway_default_analytics_errorevents-000001<br/>gateway_default_analytics_performancemetrics-000001<br/>gateway_default_analytics_transactionalevents-000001<br/>gateway_default_analytics_monitorevents-000001 | store for runtime transactions                               | gateway_default_analytics_<Analytics_Event_Type><br>gateway_default_analytics_policyviolationevents<br/>gateway_default_analytics_threatprotectionevents<br/>gateway_default_analytics_lifecycleevents<br/>gateway_default_analytics_errorevents<br/>gateway_default_analytics_performancemetrics<br/>gateway_default_analytics_transactionalevents<br/>gateway_default_analytics_monitorevents |
| gateway_default_dashboard                                    |                                                              |                                                              |
| gateway_default_license                                      | store for license details                                    |                                                              |
| gateway_default_audit_auditlogs-000001                       | store for audit logs                                         | gateay_default_audit_auditlogs                               |
| gateway_default_cache_cachestatistics                        | store for cache statistics                                   |                                                              |
| gateway_default_log-000001                                   | store for application logs                                   | gateway_default_log                                          |

#### Choosing number of primary shards per index

When it comes to sharding and replication of the above indices, API Gateway sets the number of primary shards based on the maximum number of documents and size of documents.  Below table gives a clear picture on shards allocation.

| Index type                                | Elasticsearch types                                          | Max # of documents | Number of primary shards |
| :---------------------------------------- | :----------------------------------------------------------- | :----------------- | :----------------------- |
| Types with data in between 1 GB and 30 GB | apis, applications, registeredapplications, strategies       | 10,00,000          | 2                        |
| Types with data < 1 GB                    | other types in gateway_default, gateway_default_license, gateway_default_analytics (Other than transactional events) | 1000               | 1                        |
| Types with data keep on growing (>30GB)   | gateway_default_log, gateway_default_audit and gateway_default_analytics_transactionalEvents | Keeps growing      | 5                        |

For indices where data keeps growing, API Gateway assigns 5 primary shards and there is no issue until the data in the index grows up-to 125 GB (25 GB per primary shard). When the data in the index grows more than 125 GB (maximum), each primary shard size will go beyond the suggested 25 GB. To prevent that, API Gateway suggests a solution to write subsequent data to the new index using rollover index API.

The rollover index API rolls an [alias](https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-aliases.html "Update index alias API") to a new index when the existing index meets a condition, you provide. For example, you need to rollover an index when the total index size is greater than (number of primary shards \* 25gb. )

So for the gateway\_default\_analytics\_transactionalevents index, which has 5 primary shards,  you should consider rolling over when the index size reaches 125 GB 

> Use rollover API after applying the 10.5 Fix 4
>
> At the time of rollover, please check the available disk space, heap space and increase, if required
>
> Rollover is possible for all the 7 analytics event types, audit logs and application logs
>


It is important to note that it is your responsibility to check the current size of the index (shards) and decide when to call the roll over API. 

 You can create a scheduler to check whether the size reached a threshold limit (say 80% for safer side) periodically and call roll over API, if it's required.  
In the above example, threshold size is 100 GB (80% of 125 GB)  
Curl command to view the index (shards) size is [http://<HOST\_NAME>:<ES\_PORT>/\_cat/indices?index=<INDEX\_NAME>&v](http://localhost:9240/_cat/shards?index=gateway_default_apis&v) and find the _pri.store.size_ field (size) in the response as shown in the below screenshot

![](attachments/627409723/636150584.png)

Please find the below rollover API example to be used when the transactional events exceeds 125GB.

**Sample rollover index API**

POST /gateway\_default\_analytics\_transactionalevents/\_rollover

```
{
  "conditions": {
    "max\_size":   "125gb" 
  }
}
```


For more details on rollover index API, please refer [Rollover index](https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-rollover-index.html). 

#### High availability

*   High availability will be achieved by configuring right number of replica shards. You can use the replica shards values between 1 and n-1 (n - number of nodes) as per your high-availability needs.
*   When primary shard is down, one of the replica shard will become the primary shard
*   However, replica shards can serve read requests. If, as is often the case, your index is search heavy, you can increase search performance by increasing the number of replicas, but only if you also add extra hardware.

> **Note:** Please note, Replicas can be changed later point in time after the initial planning, but changing the number of shards is not trivial and Elasticsearch recommends that pre-planning for the correct number of shards is the optimal approach.

### Heap and Memory Configurations

For JVM configurations ,you can do these changes in config/jvm.options file. Take a look at [https://www.elastic.co/guide/en/elasticsearch/reference/current/jvm-options.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/jvm-options.html).

The default heap configuration for Elasticsearch is 2 GB. More often than not, in a production setup, this need to be changed. More inputs on Heap and main memory configurations can be obtained from [https://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html](https://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html) and [https://www.elastic.co/guide/en/elasticsearch/guide/current/hardware.html](https://www.elastic.co/guide/en/elasticsearch/guide/current/hardware.html) 

### Cluster Strategy & Configurations

#### Recommendations

1.  A stable master is important for the stability of the cluster. If your cluster really grows( > 8 nodes) or seeing stability issues, its recommended to host dedicated master nodes. i.e node.master=true , node.data=false , node.ingest=false
2.  To avoid split-brain issue, it's recommended to use 3 minimum master nodes and the number of master nodes should be a odd number i.e cluster.initial\_master\_nodes: \["node1", "node2", "node3"\]
3.  By default "write" decision use "quorum".  quorum = ((primary + replica) / 2) + 1. The best that you could have is n-1 replica where n is number of nodes. This provides protection in any worst case circumstances. But more replica means more work the data is sent to all replica but in parallel. More replica is bad for write heavy applications. But this also speeds up concurrent reads as replicas share the load. Less replica is bad for read heavy applications. 2 might be a good value up to 5 nodes to start with. Replicas can be changed at anytime. 
4.  You must provide the cluster configurations in the elasticsearch.yml file in the SAG\_root/InternalDataStore/config/ folder before starting the Elasticsearch for the very first time. When you start Elasticsearch, the node will auto-bootstrap itself into a new cluster. You cannot change the configuration after bootstrap and thus, Elasticsearch will not merge separate clusters together after they have formed, even if you subsequently try and configure all the nodes into a single cluster. For more information, see [https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html)
    

### Horizontal scale-up

When the data volume grows beyond the capacity of existing nodes, we need to add new nodes to the cluster.

#### Adding new node to the cluster

A new node can be added when the database is up and running, and it does not require any change in the configurations of existing nodes.  

##### Before adding the new node

*   Update the configurations in config/elasticsearch.yml for this new node

take these configurations from an existing node and update following values :  
[node.name](http://node.name) : should be a unique name for this node 

*   Update the configurations in config/jvm.options configurations for this node

take these configurations from an existing node

*   Ensure the network backup location is setup and accessible from this new node

the path mentioned in elasticsearch.yml > path.repo must be pointing to a network location (not a local path)  
and this path should be accessible with write privilege from the new node

*   Ensure data folder is cleaned up, in case if you are re-purposing this node

##### Start new node

*   Start Elastic search in the new node.
*   After the startup, we can verify if the new node has been added successfully in the cluster through this rest call
    
    GET /\_nodes/stats
    

#### Cluster data balancing

Following configurations will help re-balancing the data within the cluster.

```
cluster.routing.allocation.disk.threshold_enabled
cluster.routing.allocation.disk.watermark.low
cluster.routing.allocation.disk.watermark.high
cluster.routing.allocation.disk.watermark.flood_stage
```

Please refer [this article](https://www.elastic.co/guide/en/elasticsearch/reference/7.2/disk-allocator.html) for further information. These settings can be updated even when the cluster is up and running. 

#### Cluster health monitoring

It is very important to know when we need to add the new node.  In any one of the existing nodes, if the system resource consumption are constantly above a threshold point, we need to add a new node. 

Following system resources are monitored in any infrastructure : CPU, System memory (RAM) & Disk usage.  In addition to this, we need to monitor Elastic Search Heap usage also. Heap usage tends to grow high when more and more shards added in the database.

Automated  health monitoring & email alert scripts must be run on regular intervals (e.g every 15 mins), which check the system statistics and  and alert the support team when there is a breach in resource usage. e.g. Send alert email to the support team when disk usage in any node > 75% or the Elastic Search heap usage > 75%.

For Elastic Search specific statistics following elastic search queries give a wealth of information : 

*GET /\_nodes/stats*
*GET /\_cluster/stats*

Apart from resource usage, these queries provide many other useful statistics also, such as index count, shards count, documents count, store size etc.   

### Securing Elasticsearch

Refer to [Securing Elasticsearch for API Gateway 10.5](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing+Elasticsearch+for+API+Gateway+10.5) for more information on securing Elasticsearch.

### Data Management 

You can use API Gateway's Backup utilities to periodically back up the data in API Gateway.     

#### Backup and restore

When you perform backup, API Gateway does only an incremental backup of your data.  API Gateway backup and restore command line utility will help you to perform backup and restore of API Gateway data. You can refer to the  [Back up and restore of API Gateway assets](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Back+up+and+restore+of+API+Gateway+assets) and [Periodically backup Data](https://iwiki.eur.ad.sag/display/RNDWMGDM/Periodically+backup+Data) for more details. 

Every time you backup your data, Elasticsearch creates a new snapshot that is incremental to the previous snapshot.  When you delete a snapshot, the data is not deleted. It just means that you cannot restore to that point in time where the deleted snapshot was taken.  If you want to remove the data (depending on the data retention period), then you should be using the purge operation provided by API Gateway, which will remove the data from the Elasticsearch store. For example, let's say your data retention period is 90 days and on 91st day you want to delete the data that was created on the 1st day.  In this case, you can do a purge operation on the 1st day's data.  So when you restore the backup that was created on 91st day, you will have the data available from 2nd day to 91st day. But when you restore the snapshot taken on 90th day, you will see the data from 1st day to 90th day.  

So it is up to you to decide, how many snapshots to maintain. To avoid delay in future snapshots maintain less number of older snapshots. Following command helps to clean up the older snapshots.    

**Clear the older snapshots**

```
cd <apigatewayInstallationLocation>\\IntegrationServer\\instances\\default\\bin

To List all the older backup
apigatewayUtil<.bat|.sh> list backup

All the created backups will be list in chronological sequence with the oldest backup listed first.

Example:-
./apigatewayUtil.sh list backupBackups available in default are

default-2019-may-27-15-18-3-618000000
default-2019-may-27-15-18-38-752000000
default-2019-may-27-15-18-48-435000000
default-2019-may-27-15-21-43-506000000

To delete a backup
apigatewayUtil<.bat|sh> delete backup -name <backupName>

Example:
./apigatewayUtil.sh delete backup -name default-2019-may-27-15-18-3-618000000  
```

#### Archive and Purge

API Gateway provides Archive and purge options for Runtime transactions, Application logs and Audit logs. It is important to make sure you have an estimate of the data that you might store depending on your data retention strategy to help manage the data.  Typically after your planned data retention period, you will have 2 options 

1.  Purge old data
2.  Archive and purge the data 

To get the status of the archive / purge operation based on the job id, use the below REST API

```
curl --location --request GET 'http://localhost:5555/rest/apigateway/apitransactions/jobs/<JOB\_ID>' \\
--header 'Accept: application/json' \\
--header 'Authorization: Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U='
```

By default, the archived file is stored in <IS\_Installed\_Folder>\\profiles\\IS\_default\\workspace\\temp\\default and you can configure the custom location using the extended setting 'backupSharedFileLocation' and API Gateway provides option to archive the transactions, audit or applications logs data from the UI.  For automation, you can use the Administration REST APIs (APIGatewayAdministration.json).

#### Expired token cleanup

This is applicable only when the API Gateway's local authorization server is used as the OAuth token issuer. On a day to day basis if your API Gateway instance issues a large number of OAuth tokens, then it is a good idea to clean up the expired tokens from the database. To be specific, this cleanup is recommended if you see more than 10,000 documents in the "gateway\_{default}\_oauth2materializedtoken" index. This cleanup can be accomplished simply by running the IS service pub.oauth:removeExpiredAccessTokens. 

### Dynamic configuration updates

Elasticsearch APIs can be used to update most of the configurations dynamically.  You use the Cluster settings API to perform the configuration changes. Please refer to [https://www.elastic.co/guide/en/elasticsearch/guide/current/\_changing\_settings\_dynamically.html](https://www.elastic.co/guide/en/elasticsearch/guide/current/_changing_settings_dynamically.html) and [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/cluster-update-settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/cluster-update-settings.html)  for more details.

You can find the list of all configurations that can be dynamically updated at [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/modules.html#modules](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/modules.html#modules)

### Monitoring

For Elasticsearch monitoring, no plugins are shipped along with API Gateway but there are lot of good plugins available available in the web.  [X-pack](https://www.elastic.co/guide/en/x-pack/current/xpack-introduction.html) is a commercial monitoring solution from the same company which created Elasticsearch. The other good open source alternatives are

1.  [Elastic-HQ](http://www.elastichq.org/)
2.  [Elasticsearch-kopf](http://elasticsearch-kopf/)
3.  [Bigdesk](http://bigdesk.org/)
4.  [Elasticsearch-head](https://github.com/mobz/elasticsearch-head)

### Across Data Centre deployment 

Elastic search does not encourage the deployment of ES across datacentres but have proposed few alternatives for the same. 

Refer [https://www.elastic.co/blog/clustering\_across\_multiple\_data\_centers](https://www.elastic.co/blog/clustering_across_multiple_data_centers).

### Troubleshooting guide

| Issue                                                        | Error log                                                    | Solution                                                     |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| Issue                                                        | Error log                                                    | Solution                                                     |
| Limit of total fields [1000] in index [gateway_default_analytics_<TYPE>] has been exceeded | 2019-09-19 00:29:02 UTC [YAI.0300.9999E] error while saving doc Index - gateway_default_analytics, typeName - transactionalEvents: POST http://10.177.129.5:9241/gateway_default_analytics/transactionalEvents: HTTP/1.1 400 Bad Request {"error":{"root_cause":[{"type":"illegal_argument_exception","reason":"Limit of total fields [1000] in index [gateway_default_analytics] has been exceeded"}],"type":"illegal_argument_exception","reason":"Limit of total fields [1000] in index [gateway_default_analytics] has been exceeded"},"status":400} | [PUT /gateway_default_analytics_/_settings](http://vmseshasai03w:9240/gateway_default/_settings){ "index.mapping.total_fields.limit": 20000  } |
| Customer encountered low disk space issue and API Gateway stopped working for WRITE operations | Exception: [WARN ][o.e.c.r.a.DiskThresholdMonitor] [localhost1568897216386] flood stage disk watermark [95%] exceeded on [BOf6SQe2SwyI93vi4RlBNQ][localhost1568897216386][C:\SoftwareAG\InternalDataStore\data\nodes\0] free: 2.4gb[2.4%], all indices on this node will be marked read-onlySaving an API -> error message ("Saving API failed. com.softwareag.apigateway.core.exceptions.DataStoreException: Error while saving the document. doc Id - 6d5c7ac0-574a-4a53-acba-a738f21e3142, type name - _doc, message - "index [gateway_default_policy] blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];" ") | Low disk space available. Cleanup disk space.curl -XPUT -H "Content-Type: application/json" http://localhost:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}' |
| Dangling Index. The dangling index problem related to elasticsearch. This will occur, when we have indices with same name created in different elasticsearch first and form an elasticsearch cluster. This means, that elasticsearch doesn't know which index needs to be synced as the index with same name already available in other nodes. In API gateway context, when we start the API Gateway nodes separately with out forming as cluster and then form the cluster, we will get this issue. | [2019-12-17T10:01:34,633][WARN ][o.e.g.DanglingIndicesState] [s1gp-igw01-gsb.sgi-idm.fednet.intra1566308686237] [[gateway_default_cache/rSspQXrrRKGdQCwS8KaYHg]] can not be imported as a dangling index, as index with same name already exists in cluster metadata | As a precondition - we need to form the elasticsearch cluster first then start all elasticsearch then start API gateway node one by one.Once the dangling indices issue occurs, we need to delete the indices in all elasticsearch nodes, then follow the precondition steps. |
| Elastic Search Server not starting - bootstrap checks failed | [2020-03-25T09:09:20,298][INFO ][o.e.b.BootstrapChecks ] [itsbebel00471.jnj.com1585050877659] bound or publishing to a non-loopback address, enforcing bootstrap checks [2020-03-25T09:09:20,299][ERROR][o.e.b.Bootstrap ] [itsbebel00471.jnj.com1585050877659] node validation exception [1] bootstrap checks failed [1]: system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk | Add **bootstrap.system_call_filter: false** setting to elasticsearch.yml |
| Accessing audit logs causing internal datastore to crash     | [2020-03-03T10:03:33,857][ERROR][o.e.ExceptionsHelper   ] [[daeipresal43558.eur.ad](http://daeipresal43558.eur.ad/).sag1580968109910] fatal error    at org.elasticsearch.ExceptionsHelper.lambda$maybeDieOnAnotherThread$2(ExceptionsHelper.java:310)    at java.util.Optional.ifPresent(Optional.java:159)    at org.elasticsearch.ExceptionsHelper.maybeDieOnAnotherThread(ExceptionsHelper.java:300)    at org.elasticsearch.http.netty4.Netty4HttpRequestHandler.exceptionCaught(Netty4HttpRequestHandler.java:76)   [2020-03-03T10:03:33,858][ERROR][o.e.ExceptionsHelper   ] [[daeipresal43558.eur.ad](http://daeipresal43558.eur.ad/).sag1580968109910] fatal error    at org.elasticsearch.ExceptionsHelper.lambda$maybeDieOnAnotherThread$2(ExceptionsHelper.java:310)    at java.util.Optional.ifPresent(Optional.java:159)    at org.elasticsearch.ExceptionsHelper.maybeDieOnAnotherThread(ExceptionsHelper.java:300)    at org.elasticsearch.http.netty4.Netty4HttpRequestHandler.exceptionCaught(Netty4HttpRequestHandler.java:76)  [2020-03-03T10:03:33,867][ERROR][o.e.b.ElasticsearchUncaughtExceptionHandler] [[daeipresal43558.eur.ad](http://daeipresal43558.eur.ad/).sag1580968109910] fatal error in thread [Thread-176], exiting java.lang.OutOfMemoryError: Java heap space | After setting the property -XX:MaxDirectMemorySize=4095m you can able to access elasticsearch audit log data without any problem.Reference: https://github.com/elastic/elasticsearch/issues/44174.So, the only solution to this problem is to set or increase the MaxDirectMemorySize. For example, if 4g is the value of HeapSize, that's equal to 4096m, so -XX:MaxDirectMemorySize=4095m should be effective. |
