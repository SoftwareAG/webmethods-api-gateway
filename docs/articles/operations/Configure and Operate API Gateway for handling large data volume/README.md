Configure and Operate API Gateway for handling large data volume
=====================================================================================

*   [Purpose](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Purpose) 
*   [Test Details](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-TestDetails)
    
    *   [Tests done](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Testsdone) 
    *   [Test Environment Details](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-TestEnvironmentDetails)
    
*   [General recommendation on startup/shutdown sequence](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Generalrecommendationonstartup/shutdownsequence) 
    
    *   [Startup Sequence](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-StartupSequence)
    *   [Shutdown Sequence](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-ShutdownSequence)
    
*   [Product Configurations](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-ProductConfigurations)
    
    *   [API Gateway - Elasticsearch/Internal Datastore communication](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-APIGateway-Elasticsearch/InternalDatastorecommunication) 
    *   [Elasticsearch/InternalDataStore configuration](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Elasticsearch/InternalDataStoreconfiguration)
    *   [Kibana Configuration](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-KibanaConfiguration)
    *   [API Gateway Configuration](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-APIGatewayConfiguration)
    
*   [Operating API Gateway](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-OperatingAPIGateway)
    
    *   [Data house keeping](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Datahousekeeping)
        
        *   [Backup](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Backup)
        *   [Restore](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Restore)
        *   [Purge](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Purge)
            
            *   [Default Approach](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-DefaultApproach)
            *   [Alternate Approach](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-AlternateApproach)
            
        
    *   [Logs Housekeeping](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-LogsHousekeeping)
        
        *   [Log File Rotation Settings:](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-LogFileRotationSettings:)
            
            *   [Elasticsearch](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Elasticsearch)
            *   [API Gateway](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-APIGateway)
            *    [Kibana configuration](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Kibanaconfiguration)
            
        
    *   [Monitoring and Alerting](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitoringandAlerting)
        
        *   [Monitor Elasticsearch Shards](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorElasticsearchShards)
            
            *   [Monitor Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorCriteria)
            *   [Actions](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Actions)
            
        *   [Monitor Disk Space](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorDiskSpace) 
            
            *   [Monitor Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorCriteria.1)
            *   [Actions](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Actions.1)
            
        *   [Monitor Elasticsearch Cluster Health](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorElasticsearchClusterHealth)
            
            *   [Monitor Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorCriteria.2)
            *   [Actions](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Actions.2)
            
        *   [Monitor the number of shards](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Monitorthenumberofshards)
            
            *   [Monitor Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorCriteria.3)
            *   [Actions](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Actions.3)
            
        *   [Monitor API Gateway Health](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorAPIGatewayHealth)
            
            *   [Monitor Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-MonitorCriteria.4) 
            *   [Actions](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Actions.4)
            
        
    *   [Scaling](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Scaling)
        
        *   [Scale Elasticsearch nodes](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-ScaleElasticsearchnodes)
            
            *   [Scaling Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-ScalingCriteria)
            *   [Steps to scale up](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Stepstoscaleup)
            *   [Steps to scale down](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Stepstoscaledown)
            
        *   [Scale API Gateway nodes](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-ScaleAPIGatewaynodes)
            
            *   [Scaling Criteria](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-ScalingCriteria.1)
            *   [Steps to scale up](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Stepstoscaleup.1)
            *   [Steps to scale down](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-Stepstoscaledown.1)
            
        
    *   [Data Separation](#ConfigureandOperateAPIGatewayforhandlinglargedatavolume-DataSeparation)
    

Purpose 
========

The purpose of this document is to share product configurations and recommendations that are required to setup API Gateway to handle large volumes of data. These are recommendations arrived at as an outcome of SOAK testing.  This document must be treated and read as a case study document and not as an official bench marking document.   

Test Details
============

Tests done 
-----------

The configurations and recommendations provided in this document are based on observations from a soak testing done on a API Gateway cluster. In addition, other tests done are backup, restore, archive & purge (events), restoring events from the archive. Here are the test details 

  

Test type

Test Details

1

Soak testing  
  
  

Test Duration

100 days

Transaction per second (TPS)

200

Transaction size

10 KB

Test completion target

2 Billion transactions

ES Store size

2940 GB (with 1 replica)  
i.e., 1470 GB primary data

2

Backup

Backup type

Incremental backup (every 8 hours)

3

Restore

Transactions count in snapshot (backup) when the restore was attempted

1.377 Billion transactions

Snapshot size

960 GB

4

Archive & Purge (events)

Transactions count in Elasticsearch when archive & purge was attempted

1.377 Billion

5

Restoring events from the archive

Transactions count in the archive when it was restored

1.377 Billion

Test Environment Details
------------------------

Purpose

No of  
nodes

Node configurations

RAM

CPU

Disk space

API Gateway with Internal datastore

Version 10.5

3

8 GB

2 GHz \* 2

250 GB

Terracotta cluster.

Nginx Load balancer was installed in one of the Terracotta nodes

2

4 GB

2 GHz \* 2

50 GB

Client - JMeter

1

8 GB

2 GHz \* 2

50 GB

Native server (Integration Server)

2

4 GB

2 GHz \* 2

50GB

Elasticsearch Horizontal scaleup (These VMs are available in a VM pool and added to the ES cluster only when needed)

6

4 GB

2 GHz \* 2

500GB

General recommendation on startup/shutdown sequence 
====================================================

Startup Sequence
----------------

1.  Start Terracotta
2.  Start Elasticsearch nodes
3.  Start API Gateway 

Shutdown Sequence
-----------------

1.  Stop API Gateway
2.  Stop Elasticsearch
3.  Stop Terracotta

Product Configurations
======================

API Gateway - Elasticsearch/Internal Datastore communication 
-------------------------------------------------------------

This section defines the configurations needed to make API Gateway connect to desired Elasticsearch cluster. Set the below properties in _system-settings.yml_ available _<install location>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\resources\\configuration_ in all API Gateway nodes.

Note

By default, the externalized configuration won't be available. A default template available under <installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\resources\\configuration. You need to add the desired settings in **system-settings.yml**. Then you have to let API Gateway know that this is a configuration file by enabling the file in **config-source.yml** by uncommenting the appropriate lines. Please refer to the attached files for reference - [config-sources.yml](attachments/722053401/722053402.yml) and [system-settings.yml](attachments/722053401/722053403.yml)

  

Configuration

Explanation

apigw.elasticsearch.autostart =**false**

Since the Elasticsearch cluster will be started before API Gateway, setting this to false so that API Gateway won’t try to start Internal data store.

apigw.elasticsearch.hosts=**<ElasticsearchLB or Elasticsearchhost>:<es port>**

Example -  apigw.elasticsearch.hosts=localhost:9240

It is enough to provide one host and port, provided all the Elasticsearch can be connected via publish address set in Elasticsearch. 

apigw.elasticsearch.sniff.enable=**false**

By default, this value will be true. So that it will get the list of Elasticsearch nodes available in the Elasticsearch cluster and send request from API Gateway to all Elasticsearch nodes to balance the request across all the nodes.

Set this value to false only on below scenarios

1.  If Load balancer host and port of Elasticsearch is specified for apigw.elasticsearch.hosts, then this should be set to false.
2.  Check the publish address of Elasticsearch clusters. If they are not accessible, then set this to false and provide all host and port in **apigw.elasticsearch.hosts** property. The publish address can be find using http://<eshost>:<esport>/\_nodes/http

Elasticsearch/InternalDataStore configuration
---------------------------------------------

OOTB, Elasticsearch, or internal data store will have a default configuration.  Please see the below recommendation to set up the initial Elasticsearch cluster

Configuration

Explanation

Minimum number of nodes

Minimum number of nodes required is 3

Set all three nodes as master. 

By default, all nodes will be master unless explicitly set node.master as false

Set minimum heap space as 2gb

Follow below steps to increase or decrease heap space of Elasticsearch node

1.  Go to -> <Install\_location>\\InternalDataStore\\config\\jvm.options
2.  Change the value of property -Xmx<number>g.ex: to increase from 2g to 4g, customer can set the value as -Xmx4g

node.name

Set a human readable node name by setting [node.name](http://node.name) in elasticsearch.yml in all nodes

Initial master nodes

Add all the three node names in [initial.master\_nodes](https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-discovery-bootstrap-cluster.html) in elasticsearch.yml. These are the nodes that are responsible for forming a single cluster for the very first when we start Elasticsearch cluster. As per Elasticsearch recommendation add at least three master eligible nodes in cluster.initial.master\_nodes

Discovery seed hosts

Add the three nodes host:httpport as discovery.seed\_hosts. Elasticsearch will discover the cluster nodes using the hosts specified in this property.

Path Repo

Configure the **repo** to common location that is accessible for all Elasticsearch nodes. All the backups taken using either Elasticsearch snapshot or API Gateway backup utility will be stored here. Refer this article [https://techcommunity.softwareag.com/pwiki/-/wiki/Main/Periodical%20Data%20backup](https://techcommunity.softwareag.com/pwiki/-/wiki/Main/Periodical%20Data%20backup)

1.  Backup to [AWS S3](https://www.elastic.co/guide/en/elasticsearch/plugins/current/repository-s3.html) bucket or shared file system options are available, so that the local disk space will not be occupied.

Refresh Interval

After starting the API Gateway, set the [refresh](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html) interval for events index type as below

1.  Go to API Gateway UI -> Administration -> Extended settings -> **eventRefreshInterval** to 60s and save it. In Elasticsearch, the operation that makes any updates to the data visible to search is called a refresh . It is costly operation when there are large volumes of data and calling it often while there is ongoing indexing activity can impact indexing speed. The below queries will make the index refresh every 1 minute

[Disk based shard allocation settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/disk-allocator.html)

If node disk spaces are equal, then provide the percentage

Elasticsearch uses the below settings to consider the available disk space on a node before deciding whether to allocate new shards to that node or to actively relocate shards away from that node. 

1.  cluster.routing.allocation.disk.watermark.low

**Default: 85%** which means Elasticsearch will stop allocating new shards to nodes that have more than 85% disk used

1.  cluster.routing.allocation.disk.watermark.high

**Default: 90%** which means Elasticsearch will attempt to relocate shards away from a node whose disk usage is above 90%

iii.    cluster.routing.allocation.disk.watermark.flood\_stage

**Default: 95%** which means Elasticsearch enforces a read-only index block (index.blocks.read\_only\_allow\_delete) on every index that has one or more shards allocated on the node that has at least one disk exceeding the flood stage. This is the last resort to prevent nodes from running out of disk space.

The values can be set in percentage and absolute. If the nodes have equal space, then the customer can configure the values in

curl -X PUT "[http://localhost:9240/\_cluster/settings?pretty](http://localhost:9240/_cluster/settings?pretty)" -H 'Content-Type: application/json' -d'

{

    "persistent" : {

    "cluster.routing.allocation.disk.watermark.low": "75%",

    "cluster.routing.allocation.disk.watermark.high": "85%",

    "cluster.routing.allocation.disk.watermark.flood\_stage": "95%",

    "[cluster.info](http://cluster.info).update.interval": "1m"

  }

}

  

If the node disk spaces are not equal, then provide in absolute value. Set the absolute value based on disk size available. Ex:

curl -X PUT "[http://localhost:9240/\_cluster/settings?pretty](http://localhost:9240/_cluster/settings?pretty)" " -H 'Content-Type: application/json' -d'

{

  " persistent" : {

    "cluster.routing.allocation.disk.watermark.low": "100gb ",

    "cluster.routing.allocation.disk.watermark.high": "50gb",

    "cluster.routing.allocation.disk.watermark.flood\_stage": "10gb",

    "[cluster.info](http://cluster.info).update.interval": "1m"

  }

}'

Kibana Configuration
--------------------

If External Kibana is used, perform the following steps to turn off internal Kibana and use external Kibana

Configuration

Explanation

Autostart

Go to: <installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\resources\\configuration \\system-settings.yml and set apigw.kibana.autostart=false and update the apigw.kibana.elasticsearch.hosts=http(s)://<eshost>:<esport>

Follow this in all API Gateway nodes.

Dashboard Instance

Go to: <installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\resources\\configuration \\system-settings.yml and set apigw.kibana.dashboardInstance=http://<host>:<kibanaport> (eg: [http://localhost:9405](http://localhost:9405))

Request Timeout

Perform this step irrespective of whether you use external Kibana or the one bundled with API Gateway. Change timeout setting for Kibana. Go to kibana.yml, **elasticsearch.requestTimeout** property changed from the default value (30s) to 120s.

This timeout setting is responsible to make Kibana waits for responses from Elasticsearch.

For rendering analytics for high volume (say 500Mn or 1Bn transactions) change this.

**Note**: This setting worked till 1.6Bn after which we increased it to 180s.

API Gateway Configuration
-------------------------

Configuration

Explanation

Watt properties for handling high volumes

watt.security.ssl.cacheClientSessions=true

[watt.net](http://watt.net).maxClientKeepaliveConns=500

watt.server.threadPool=900

watt.server.threadPoolMin=200

[watt.net](http://watt.net).clientKeepaliveUsageLimit= 10000000

API Gateway extended settings for handling high volumes

To handle high TPS between API Gateway and Elasticsearch for logging transactions

events.collectionPool.maxThreads = 16

events.ReportingPool.maxThreads = 8

Operating API Gateway
=====================

Data house keeping
------------------

### Backup

**1. Create backup**

Customer can use the below command to back up the API Gateway data. Go to _<Installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\cli_ and execute below command periodically (daily or weekly)

**Backup**

apigatewayUtil.bat/sh create backup -name <backupName> -tenant <default or configured tenant name> -repo <repo\_name>

  

**2\. Verify the backup**

Go to _<Installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\cli_ and execute below command

**Backup**

apigatewayUtil.bat/sh status backup -name <backupName> -tenant <default or configured tenant name> -repo <repo\_name>

  

Note

For periodical backup, the backup name should be different and meaningful to use it for restore.

**3\. Housekeeping of backup**

Generally, we will take snapshots periodically either daily or weekly or some defined period. It is better to clean up the old snapshots (backup) to clear diskspace of backup after some time or according to your data retention period.

*   **List the backups** - Go to _<Installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\cli_ and execute below command
    
    **Backup**
    
     apigatewayUtil.bat/sh  list backup -tenant <default or configured tenant name> -repo <repo\_name>
    
*   **Delete the old backups** -  _Go to <Installlocation>\\IntegrationServer\\instances\\<tenant>\\packages\\WmAPIGateway\\cli_ and execute below command
    
    **Backup**
    
    apigatewayUtil.bat/sh  delete backup -name <name of the backup to delete> -tenant <default or configured tenant name> -repo <repo\_name>
    

**4\. Schedule Periodic backup:**

Refer to this article [https://techcommunity.softwareag.com/pwiki/-/wiki/Main/Periodical%20Data%20backup](https://techcommunity.softwareag.com/pwiki/-/wiki/Main/Periodical%20Data%20backup)  Backup to AWS S3 bucket is also available so that the disk space will not be occupied.

### Restore

To Restore a backup using API Gateway utility tool.

**Restore**

apigatewayUtil.bat/sh restore backup -name <backupName> -tenant <default or configured tenant name> -repo <repo\_name>

 User can restore specific assets. Use _apigatewayUtil.bat/sh_ -help to get to know more about commands and its options

### Purge

#### **Default Approach**

*   **Purge from UI:**

Users can perform the purge operation through UI. Go to API Gateway -> Administration -> Manage Data -> Archive and purge. Select the desired event type and time duration and click purge. The purge job will get triggered.

*   **Purge using Rest Endpoint:**
    
    Purge the events using below endpoint
    
    **Purge**
    
    http://localhost:5555/rest/apigateway/apitransactions?eventType=<eventtype>&objectType=Analytics&olderThan=<timeline>
    
    eventType: \[ "ALL", "transactionalEvents", "lifecycleEvents", "performanceMetrics", "monitorEvents", "threatProtectionEvents" ,"policyViolationEvents", "errorEvents", "auditlogs", "applicationlogs"\]
    
    olderThan: You specify years or months or days along with time
    
    Year: <number>Y \[example: 1Y\]
    
    Month: <number>M \[example: 2M\]
    
    days: <number>d \[example: 90d\]\\
    
    time: <number>h<number>m<number>s \[example: 14h30m2s\]
    
    Example: Purging data that are older than 90days and 2hours 3minutes old
    

**Purge**

curl -X DELETE -H "Authorization: Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=" -H "Accept: application/json"  "http://localhost:5555/rest/apigateway/apitransactions?eventType=ALL&objectType=Analytics&olderThan=90d2h3m"

The rest endpoint will return the job id if the request for the purge is successful. Check whether the purge is successful using the below endpoint

**Purge**

http://localhost:5555/rest/apigateway/apitransactions/jobs/<job\_id>

*   **Schedule Periodic Purge:**

It is important to schedule the purge operation using the rest endpoint periodically based on your analytics retention time

  

Note

**Note**: Elasticsearch purging is a time, memory, and disk space consuming process. Do this whenever there is less load on the server.

#### **Alternate Approach**

To avoid purge, the user can follow below approach. Users can rollover events related indices (check this [document](https://github.com/SoftwareAG/webmethods-api-gateway/tree/master/docs/articles/architecture/Elasticsearch%20Best%20Practices%20(v7.2.0)) for details on different indices and their usage) on a daily or defined period. The Rollover of an index is nothing but, making the current index having events as read-only and creating a new index for storing new events and linking that to the existing alias.  This allows us to delete the oldest index based on the date instead of purging old events. 

The deletion of the index is almost instant and the disk space of the oldest events are recovered immediately.

Users can rollover the events-related indices. Please refer monitoring section to check how to rollover an index.

Rollover index options:

*   **Daily rollover**:

If the user daily rollover the index, user should check the number of shards across the cluster while rollover. Daily roll over the index will increase the shards. Elasticsearch recommends, it is best practice to have 20 shards per GB of heap space allocated.

To overcome the shards increasing rate, based on the above experiment for 200 days 2.9 TB of disk space used. Hence on an average per day 15 GB of disk space is used to store for primary and replica. Based on the above values, for events user can set 1 primary and 1 replica for daily roll over. During the rollover of an index, user can specify the number of primary and replicas for roll over index (new index).

*   **Based on Disk Size**

If user doesn’t want to alter the number of shards, then they can decide the period based on disk size. Whenever the events index size reaches 25 GB per shard or ( number of shards \* 25 GB) then they can roll over the events to new index. But in this approach, the events will be stored in periods and user can delete events in period.

For example: If the transaction events, to reach 125 GB ( 5 primary shards)  it takes 10 days then the events will be stored in 10 days period.  So, every tenth day user can roll over the index ( create new index to store events ) and delete the oldest index that crosses the retention period.

User can rollover the events related index periodically and can provide index name in the format _gateway\_<tenant>\_<eventType>\_yyyymmdd_ format during rollover

Example to rollover transactional event by date. Creating a new index with date to store data that are generated after 6th Jan 2021 to new index.

**Rollover**

curl -X POST  "http://localhost:9240/gateway\_default\_analytics\_transactionalevents/\_rollover/gateway\_default\_analytics\_transactionalevents\_20210106"-H "content-type: application/json"  -d "{}"

By this way, whenever we roll over, we can delete the oldest index based on date instead of purging old events.

For example, we can delete the index from 4th October 2020  by just computing the index name as following gateway\_default\_transactionalevents\_20201004. We can delete the index that is older than 90 days (retention period) by just computing the index name. This will be very simple as deletion of index happens instantly and can be done any time.

All events indices beyond a particular month can be easily identified and deleted. If the user wants to delete all events indices created on October2020, they can use the below query to list all the events indices that belongs to October2020  and can delete the listed indices

**Rollover**

http://localhost:9240/\_cat/indices/gateway\_default\_analytics\_\*events\_202010\*?v&s=i

Logs Housekeeping
-----------------

It is important to manage the log files.

By default, the logs will be stored in the below location

1.  <install location>\\IntegrationServer\\instances\\<instanceName>\\logs
2.  <install location>\\profiles\\IS\_<instnaceName>\\logs
3.  <install location>\\InternalDataStore\\logs

### Log File Rotation Settings:

Please set the properties for each component to enable automatic log rotation

#### Elasticsearch

Go to <install location>\\InternalDataStore\\config\\log4j2.properties and set the below properties

**Key**

**Value**

**Possible values**

appender.rolling.strategy.action.condition.nested\_condition.type

IfAny

IfAny/IfAccumulatedFileSize

appender.rolling.strategy.action.condition.nested\_condition.exceeds

256MB

File Size units : MB/GB

appender.rolling.strategy.action.condition.nested\_condition.lastMod.type

IfLastModified

  

appender.rolling.strategy.action.condition.nested\_condition.lastMod.age

7D

  

#### API Gateway

Change the below watt properties to enable log rotation for the Integration server

**Key**

**Value**

**Comments**

watt.server.serverlogFilesToKeep

100

  

watt.server.serverlogRotateSize

10MB

File Size units : MB/GB

watt.server.audit.logFilesToKeep

100

  

watt.server.audit.logRotateSize

10MB

  

To enable log rotation for OSGI and wrapper set the below properties

**OSGI Logs** : /opt/softwareag/profiles/IS\_APIGateway/configuration/logging/log4j2.properties

**Key**

**Value**

**Comments**

appender.rolling.policies.size

10MB

  

appender.rolling.strategy.max

30

  

**Wrapper Logs**: IS\_APIGateway/configuration/custom\_wrapper.conf

**Key**

**Value**

**Comments**

wrapper.logfile.maxfiles

30

  

wrapper.logfile.maxsize

10MB

  

####  Kibana configuration

To enable log rotation for kibana please set the below properties in <install location>\\profiles\\IS\_default\\apigateway\\dashboard\\config\\kibana.yml

**Key**

**Value**

**Comments**

logging.dest

./kibana.log

  

logging.rotate.enabled

true

  

logging.rotate.everyBytes

10485760

  

logging.rotate.keepFiles

30

  

Monitoring and Alerting
-----------------------

### Monitor Elasticsearch Shards

#### Monitor Criteria

**Monitor**

curl -X "GET" "http://localhost:9240/\_cat/shards?v&s=store:desc"

This will display all the shards with disk space sorted in descending order  From the response, get the disk size used by each shard. If the shard disk size is about to reach 25GB or equals to or more than 25 GB, then take the below actions.

#### Actions

Any one of the below actions can be taken to recover disk space

*   Purge the data corresponding to that index if it is events. Refer purge section

(or)

*   [Roll over the index](https://www.elastic.co/guide/en/elasticsearch/reference/7.2/indices-rollover-index.html)

By default, the API gateway has created an alias for all events. Below are the aliases ([http://localhost:9240/\_cat/aliases?v](http://localhost:9240/_cat/aliases?v)) and you can find the corresponding index by checking [http://localhost:9240/<aliasname](http://localhost:9240/%3caliasname)\>. It will display the current write index and below is the list of aliases in API Gateway 10.5

gateway\_<tenant>\_analytics\_transactionalevents

gateway\_<tenant>\_analytics\_performancemetrics

gateway\_<tenant>\_analytics\_policyviolationevents

gateway\_<tenant>\_analytics\_lifecycleevents

gateway\_<tenant>\_analytics\_errorevents

gateway\_<tenant>\_audit\_auditlogs

gateway\_<tenant>\_analytics\_monitorevents

gateway\_<tenant>\_log

gateway\_<tenant>\_analytics\_threatprotectionevents

To rollover, an index, follow the below steps - creating a new index to write all data to that index, and the old index will become read-only.

**Rollover**

curl -X POST "http://localhost:9240/<alias>/\_rollover/<new\_index\_name>" -d "{}"

**Note**: API Gateway already created templates for adding mappings and settings for rollover index created automatically. Hence new index name should start with an alias name appended with any applicable character allowed by Elasticsearch.

Example: To rollover transactional events the request should be

**Rollover**

curl -X POST  "http://localhost:9240/gateway\_default\_analytics\_transactionalevents/\_rollover/gateway\_default\_analytics\_transactionalevents-000002"-H "content-type: application/json"  -d "{}"

### Monitor Disk Space 

#### Monitor Criteria

Use below curl command to get the [disk space of es nodes](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html)

**Monitor**

curl -X GET http://localhost:9240/\_nodes/stats/fs

It will list disk space available in all nodes. To get the disk space use the below json path expression

Total diskspace -> $.nodes.<nodeId>.fs.total.total\_in\_bytes

Free diskspace --> $.nodes.<nodeId>.fs.total.free\_in\_bytes

Available diskspace -> $.nodes.<nodeId>.fs.total.available\_in\_bytes

To know the configured disk watermark in Elasticsearch use the below command

**Monitor**

curl -X GET http://localhost:9240/\_cluster/settings?pretty

It will return the configured disk watermark as response

To Get the different level of water mark use the below json path expression

low --> $.persitent.cluster.routing.allocation.disk.watermark.low

high --> $.persitent.cluster.routing.allocation.disk.watermark.high

flood --> $.persitent.cluster.routing.allocation.disk.watermark.flood

Convert the disk space in bytes to GB (bytes/ (1024\*1024\*1024))and calculate the available diskspace percentage.

To know about any metrics customer check process specific metrics customer can use below curl command

**Monitor**

curl -X GET http://localhost:9240/\_nodes/stats/<metric>

List of metrics can be found [https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html)

#### Actions

If the available disk space matches the criteria defined in disk watermark, if the available disk space is less than what is configured in **$.persitent.cluster.routing.allocation.disk.watermark.low**  then do one of the below actions

*   Purge (refer purge section)
*   Scale up the node (refer to scaling section)
*   Add additional disk space to the existing node

### Monitor Elasticsearch Cluster Health

#### Monitor Criteria

To Know the cluster health use below

**Monitor**

curl -X GET http://localhost:9240/\_cluster/health?pretty

It will respond with cluster health status.

*   From the response check the health status by using the JSON path expression **_$.status_**
*   From the response check the number of by using JSON path expression **_$.number\_of\_nodes_**

#### Actions

If cluster health is any of the below colors

*   **Green**: No Action needed
*   **Yellow**: When Elasticsearch has huge data, it will take some time to become a green wait for 5 to 10 mins to become green. If it does not become green, we need to identify the cause for yellow and rectify that. During this time Elasticsearch will be able to process requests for the index that is available.
    *   If there are unassigned shards, then need to know the shard unassigned status and act accordingly.
        *   Execute this command to check the list of shards unassigned.
            
            **Monitor**
            
            curl -X GET “http://localhost:9240/\_cat/shards?h=index,shard,primaryOrReplica,state,docs,store,ip,node,segments.count,unassigned.at,unassigned.details,unassigned.for,unassigned.reason,help,s=index&v”
            
        *   Execute this command to check un allocation reason for specific shards
            
            **Monitor**
            
            curl -X GET "http://localhost:9240/\_cluster/allocation/explain" -d ‘{ "index" :"<index name>","primary" : "<true|false>","shard": "<shardnumber>"}’
            
*   **Red**: This might occur when Elasticsearch nodes are down or not reachable or master is not discovered.  If the number of nodes does not match the number of Elasticsearch nodes configured, identify the node that didn’t join the cluster and check that node.

### Monitor the number of shards

#### Monitor Criteria

To get the number of shards on Elasticsearch use the below command

**Monitor**

curl -X GET "http://localhost:9240/\_cluster/health?pretty"

If the total number of active shards from the response exceeds the (heap space \* nodes \* 20 ) then we need to increase the heap space of Elasticsearch nodes or add a new Elasticsearch node.

As per Elasticsearch recommendation, max 20 active shards per GB of heap space is considered healthy.

#### Actions

1.  Scale up the Elasticsearch node. Refer to the scaling section.
2.  If customers are not able to scale Elasticsearch for some reason, they can increase the heap size as the last option. The heap space should not be more than half of system memory( RAM).  (ex: If system memory is 16 GB user can allocate a maximum of 8 GB for ES and not more than in any case)

### Monitor API Gateway Health

#### Monitor Criteria 

API Gateway provides 2 key endpoints for monitoring API Gateway health. Refer to the details of these endpoints in the user guide.

**Monitor**

curl -X GET "http://localhost:5555/rest/apigateway/health/engine"
curl -X GET "http://localhost:5555/rest/apigateway/health/admin"

Additionally API Gateway also provides endpoints for metrics - [http://localhost:5555/](http://localhost:5555/rest/apigateway/health/engine)metrics 

#### Actions

*   Results from the above endpoints will point you to the problem area.  Take appropriate actions. 

Scaling
-------

### Scale Elasticsearch nodes

#### Scaling Criteria

*   Disk size

Refer monitoring section to how to check disk size.  If the available disk space matches the criteria defined in the disk watermark, then we need to add nodes.

*   Number of Shards

Refer Number of shards section under monitoring to get the number of shards..  For example, if 3 Elasticsearch node is configured with 4 GB of heap space then we can have 4 \* 3 \* 20 = 240 active shards. Refer to Elasticsearch scale-up section

#### Steps to scale up

1.  Install Elasticsearch or internal data store in the new node
2.  Configure the desired heap space.
3.  To add data node set node.master: false and node.data: true in Elasticsearch.yml file
4.  To add master node set node.master: true in Elasticsearch.yml
5.  Configure the path.repo as it is available in the other Elasticsearch nodes
6.  Set the discovery seed hosts to corresponding nodes that are in cluster.initial\_master\_nodes or provide hosts of stable master nodes. Other nodes will be automatically discovered.

#### Steps to scale down

1.  To remove a data node just shut down the node.
2.  To remove a master node that is not configured in cluster.initial\_master\_nodes
3.  Don’t remove the master node that is configured in cluster.initial\_master\_nodes as the Elasticsearch nodes will not come up if all the nodes specified in the cluster.initial\_master\_nodes are not available.

### Scale API Gateway nodes

#### Scaling Criteria

API Gateway cluster setup with the above-mentioned tuning can serve up to 200 TPS. To serve more TPS, you can scale up the API Gateway node.  Monitor the threads usage and memory utilization for scaling criteria

#### Steps to scale up

1.  Scaling up an API Gateway would mean adding a new API Gateway node to an existing cluster. Refer to the Clustering API Gateway section in API Gateway documentation for the details.
2.  If the API Gateway node is configured properly for the cluster, you can add the new node to the load balancer or add the IP of the new node to DNS server if the LB is configured to use DNS load balancing. Setting "**portClusteringEnabled**" to true in all nodes helps this node to inherit the port settings and can start serving the requests immediately.
3.  In a paired deployment setup, if a new node is getting added to DMZ, connections must be established explicitly from all nodes in the green zone to DMZ. One could use the API Gateway REST API to automate these port settings. Then the new node can be added to LB as said above.

#### Steps to scale down

1.  Put the node in "Quiesce" mode. This will start rejecting the requests and LB routs the request to other healthy nodes. Allow some cooling period for in-flight transactions to complete. Bring the instance down and remove the same from LB.
2.  Scaling down is not straightforward for Paired Gateway because of P2P communication.
    1.  To scale down the DMZ nodes, remove them from LB.
    2.  To scale down the green-zone nodes in paired gateway setup, disable the internal ports using REST API. Bring the instance down. In-flight transactions would fail as the communication channel is closed.

Data Separation
---------------

Separation of core data and analytics data is recommended for customers managing large transactions volume. Customers can use the external Elasticsearch destination feature to store all the events to separate Elasticsearch instances. This way users can separate runtime events and API Gateway core data. API Gateway core data generally will be in very less size when compared to events. Taking backup of core data will be easy and restoring the core data alone will be fast and easier to manage.

  

Attachments:
------------

![](images/icons/bullet_blue.gif) [config-sources.yml](attachments/722053401/722053402.yml) (application/octet-stream)  
![](images/icons/bullet_blue.gif) [system-settings.yml](attachments/722053401/722053403.yml) (application/octet-stream)  

Document generated by Confluence on Mar 24, 2021 07:57

[Atlassian](http://www.atlassian.com/)
