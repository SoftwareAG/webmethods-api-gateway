# API Gateway migration steps - Simplified

Author: _Madharsha, Sadiq (sadm@softwareag.com)_  
Supported Versions: 10.3 Fix 4 and above

Overview of the tutorial
------------------------

API Gateway supports migration of data from older version to newer versions. In this tutorial we will go through the following migration types in detail.

*   Migration using direct mode for standalone
*   Migration using direct mode for cluster
*   Migration using backup mode for standalone
*   Migration using backup mode for cluster

Note: This tutorial is applicable for on-premise installation only

Required knowledge
------------------

The tutorial assumes that the reader has,

*   a basic knowledge on the API Gateway as a product
*   a basic understanding on Elasticsearch (Internal Data Store)

Why?
----

In earlier versions of API Gateway i.e before 10.3 Fix 4 the migration commands were more complex which involves a multi step process. A lot of manual steps were needed to perform the migration and adding an overhead of restarting API Gateway server and Elasticsearch multiple times. In addition to that the user has to face few more struggles, some of them are, the migration didn't support migration of data from externally configured Elasticsearch and for any troubleshooting, the user has to look out multiple locations for the logs instead of single unified location which is far more easier.

The new migration utility introduced in API Gateway 10.3 Fix 4 will resolve the below issues.

*   The commands are very simple and few
*   Restart of Elasticsearch and API Gateway server is eliminated
*   Migration of Elasticsearch and IS can be done separately
*   Migration of data from externally configured Elasticsearch is supported
*   Logs all the details to a standard file, migrationLog.txt, a single file for all the log data
*   Supports reverting in case of failure in Elasticsearch migration

Prerequisite steps
------------------

Complete the below prerequisites to make you ready to get into the details of the staging and promotion in API Gateway.

*   Install source and target API Gateway instances. The version of target API Gateway should be higher than source API Gateway. Supported source API Gateway versions are 10.1 and above
*   If custom keystore files are used in the source API Gateway installation, copy the files to the same location in the target installation
*   If the target API Gateway is 10.5, then apply Fix 1

Details
-------

The migration of API Gateway can be done in two ways.

### 1\. Direct  mode

This is done by running the migration utility by referring to source Elasticsearch connection properties for migrating Elasticsearch data and the source API Gateway installation directory for migrating the IS configuration data. If the source and target Elasticsearch instances are running in the same network and can talk to each other then this method is preferred.

### 2\. Backup mode

This is done by running the migration utility by referring to the backup of source Elasticsearch data and the source API Gateway configuration backup file for migrating both the Elasticsearch data and the IS configuration. If the source and target Elasticsearch instances are running in different network and not able to talk to each other then this method is preferred.

### Migration using direct mode for standalone

Please refer [Migrating standalone API Gateway using Direct mode](Migrating%20standalone%20API%20Gateway%20using%20Direct%20mode/)

### Migration using direct mode for cluster

Please refer [Migrating API Gateway cluster using Direct mode](Migrating%20API%20Gateway%20cluster%20using%20Direct%20mode/)

### Migration using backup mode for standalone

Please refer [Migrating standalone API Gateway using Direct mode](../Migrating%20standalone%20API%20Gateway%20using%20Backup%20mode/) for migrating to API Gateway up to 10.4 versions.  

For migrating to versions 10.5 and above from lower versions, please refer to [Migrating to API Gateway 10.5 using Backup mode for standalone](../Migrating%20to%20API%20Gateway%2010.5%20using%20Backup%20mode%20for%20standalone/) 

### Migration using backup mode for cluster

Please refer [http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Migrating+API+Gateway+cluster+using+Backup+mode](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Migrating+API+Gateway+cluster+using+Backup+mode) for migrating to API Gateway up to 10.4 versions.  

For migrating to versions 10.5 and above from lower versions, please refer to [http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Migrating+to+API+Gateway+10.5+using+Backup+mode+for+cluster](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Migrating+to+API+Gateway+10.5+using+Backup+mode+for+cluster)

### General Migration configuration

API Gateway customers can modify certain parameters for migration based on their requirements by modifying the property file _**migration.properties**_ which is located at _<TARGET>\\IntegrationServer\\instances\\default\\packages\\WmAPIGateway\\bin\\migrate_. This property file is instance specific and customers can have different configurations while migrating different instances.

| **Property**                                             | **Description**                                              | **Default value** | **Possible values**                                          |
| -------------------------------------------------------- | ------------------------------------------------------------ | ----------------- | ------------------------------------------------------------ |
| apigateway.migration.srcTenantName                       | By default, the source tenant is assumed as default. But If the source API Gateway has multiple tenants, this property can be used to specify the tenant name from which the data has to be migrated to the target tenant. | default           | Any available tenant in Elasticsearch                        |
| apigateway.migration.batchSize                           | The batch size with which the data is processed. For e.g if size is 100 then by default 100 documents will be processed first. If the network is slow we can decrease this value and if the network is better we can increase this value. | 100               | Appropriate batch size. It depends on the number of documents and the size of the documents in the data store |
| apigateway.migration.logLevel                            | Log level for migration. we can change log level to debug, error etc. | info              | info,debug,error,warn,trace                                  |
| apigateway.migration.reindex.status.check.sleep.interval | Interval configuration in milliseconds. Once the re-indexing process has started from source to target instances, migration process will wake up after every configured sleep interval to check whether the re-indexing is complete. It will check the status of the task id | 5000              | Appropriate sleep interval                                   |

### Recovery

During migration, if there is any problem in the execution or any of the handlers got failed, to make sure that assets are migrated properly, we can clean the target instance once and then re run the migration. This clean command will clean the target data store  (the one configured in the config.properties of target machine) . During this procedure all the indices will be removed and this is a non reversible action. Before cleaning the data we will also take a backup of the existing data (you can also restore it). Once cleaned, we can re-run the migration. Also once you trigger the clean command, this process will wait for 5 seconds and if you wrongly triggered it and you want to kill this process you can do that with in that 5 seconds interval.

![](attachments/recovery.png)

### Clean command

**Note (Before running clean command):** If the <TARGET> is 10.5 and the clean command is executed in a cluster, go to <SOURCE>\\InternalDataStore\\config and configure path.repo property in elasticsearch.yml file for all the nodes. Make sure that the path.repo is a shared network folder and should be accessible for all the Elasticsearch nodes in the cluster. 

Go to _<TARGET>\\IntegrationServer\\instances\\default\\packages\\WmAPIGateway\\bin\\migrate_ and run the below command.

_**$> migrate.bat clean**_

**Note:** Since this command removes all the assets from data store, make sure that the target data store is properly configured in config.properties which is located at <TARGET>\\IntegrationServer\\instances\\default\\packages\\WmAPIGateway\\config\\resources\\elasticsearch.

References
----------

*   [https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
*   [https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-reindex.html](https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-reindex.html)

Learn more
----------

*   For backup and restore refer [http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Back+up+and+restore+of+API+Gateway+assets](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Back+up+and+restore+of+API+Gateway+assets)

