Handling of clear text passwords in external components of API Gateway - 10.5
==================================================================================================

### Supported Versions:

*   API Gateway version : 10.5 and above
*   External components  : 7.x versions of  Elasticsearch, Kibana and File beat

Overview of the tutorial
========================

API Gateway uses multiple external components for its various functionalities like persistence, dashboards,log aggregation etc .Some of the external components have config files containing the product related configurations which will be picked during startup. Passwords are also part of this configurations files and user should configure the secret in these configuration files as plain text. Any user who have the access to the file system can view the passwords and access these components and can tamper the data. Since they are external components, we don't have control over their configuration files and startup procedure to mask these secrets and hence we planned to utilize their obfuscation method/settings storage for hiding the passwords from the yaml files.

Required knowledge
==================

This tutorial assumes that the reader has

*   Basic understanding about the working of API Gateway
*   Good understanding about the role of the external components in API Gateway
*   Basic configuration and administration of the external components

Why?
====

As per the security standards, any product should not have the passwords as plain text either in their code or in their configuration files. These secrets must have been stored in their secret store or at least these secret strings must be obfuscated and stored. This tutorial aims at providing the step by step process for saving the passwords of the below listed external components in to their keystore storage and referring them in the configuration files.

*   Elasticsearch
*   Kibana
*   Filebeat

Prerequisite steps
==================

*   Installation of API Gateway

Details
=======

Keystore tool
-------------

Some settings are sensitive, and relying on file system permissions to protect their values is not sufficient. For this use case, Elastic stack provides a keystore tool, which may be password protected, and the keystore created stores all  the sensitive information. The password can be stored as a setting inside the keystore and the same can be referred in the yml file. During startup, the server will pick the value corresponding to the key configured and replace it. The detailed steps for creating a variable is explained in sections below. Below is the sample for using a setting available in the keystore

**Variable usage in yml**

`elasticsearch.username: ${setting_name}  
	eg: elasticsearch.password: ${sample_setting}`

  

### Points to remember

Few points to remember before trying out the keystore tool for Elasticsearch

1.  All commands here should be run as the user which will run Elasticsearch

2.  Only some settings are designed to be read from the keystore

3.  All the modifications to the keystore takes effect only after restarting the respective component
4.  The keystore tool currently only provides obfuscation. In the future, password protection will be added
5.  On a cluster setup, the settings need to be specified on each node. Currently, all the secure settings are node-specific settings that must have the same value on every node
6.  All the settings created must be configured in the yaml file. Any unused setting will block the startup
7.  The Filebeat keystore differs from the Elasticsearch and Kibana keystore. Whereas the Elasticsearch keystore lets you store `elasticsearch.yml` values by name, the Filebeat keystore lets you specify arbitrary names that you can reference in the Filebeat configuration.  

Obfuscating passwords in Elasticsearch configuration file
---------------------------------------------------------

### Creating a keystore in Elasticsearch

The below command creates a keystore. All the secrets will be stored inside this store.

**create keystore - Elasticsearch**

`bin/elasticsearch-keystore create`

The file `elasticsearch.keystore` will be created alongside `elasticsearch.yml`. If the same command is run again to create a another keystore, you will get a prompt to overwrite the existing keystore. 

### Adding a setting in Elasticsearch

The below command adds a new setting to the existing keystore. Any unused setting in the keystore will block the startup process. Make sure you use all the setting in the yaml file or remove it before startup

**create keystore**

`bin/elasticsearch-keystore add <setting_name>`

​	`eg:bin/elasticsearch-keystore add sample_setting`  

### Listing all the settings in Elasticsearch

The below command lists all the settings (only keys)  from the existing keystore.

**create keystore**

`bin/elasticsearch-keystore list`  

### Removing a setting  in Elasticsearch

The below command removes a setting from the existing keystore. 

**create keystore**

`bin/elasticsearch-keystore remove <setting_name>`

​	`eg: bin/elasticsearch-keystore remove sample_setting`


Obfuscating passwords in Kibana configuration file
-----------------------------------------------------

### Creating a keystore in Kibana

The below command creates a keystore. All the secrets will be stored inside this store.

**create keystore - Elasticsearch**

`bin/kibana-keystore create`

The file `kibana.keystore` will be created in the directory defined by the `path.data` configuration setting(by default it will be the data folder). If the same command is run again to create a another keystore, you will get a prompt to overwrite the existing keystore. 

### Adding a setting in Kibana

The below command adds a new setting to the existing keystore. Any unused setting in the keystore will block the startup process. Make sure you use all the setting in the yaml file or remove it before startup

**create keystore**

`bin/kibana-keystore add <setting_name>`

​	`eg: bin/kibana-keystore add sample_setting`

### Listing all the settings in Kibana

The below command lists all the settings (only keys)  from the existing keystore.

**create keystore**

`bin/kibana\-keystore list`  

### Removing a setting  in Kibana

The below commands removes a setting from the existing keystore. 

**create keystore**

`bin/kibana-keystore remove <setting_name>`

​	`eg: bin/kibana-keystore remove sample_setting`

**Functional Gap**

*   When Elasticsearch is secured and the credentials are provided via keystore in Kibana.yml, dashboard prompts for the authentication credentials again. This is a functional gap and cannot be bypassed. User needs to provide the Elasticsearch credentials.
*   If it is not possible to provide the Elasticsearch credentials for every session, then we cannot use the obfuscation for Kibana using keystore.

Obfuscating passwords in Filebeat configuration file
----------------------------------------------------

### Creating a keystore in Filebeat

The below command creates a keystore. All the secrets will be stored inside this store.

**create keystore - Elasticsearch**

`filebeat/filebeat_apigateway keystore create`

Filebeat creates the keystore in the directory defined by the `path.config` configuration setting.. If the same command is run again to create a another keystore, you will get a prompt to overwrite the existing keystore. 

### Adding a setting in Filebeat

The below command adds a new setting to the existing keystore. Any unused setting in the keystore will block the startup process. Make sure, you use all the setting in the yaml file or remove it before startup

**create keystore**

`filebeat/filebeat_apigateway keystore add <setting_name>`

​	`eg: filebeat/filebeat_apigateway keystore add sample_setting`



**Listing all the settings in Filebeat**

The below commands lists all the settings (only keys)  from the existing keystore.

**create keystore**

`filebeat/filebeat_apigateway keystore list`

### Removing a setting  in Filebeat

The below commands removes a setting from the existing keystore. 

**create keystore**

`filebeat/filebeat_apigateway keystore remove <setting_name>`

​	`eg: filebeat/filebeat_apigateway  keystore remove sample_setting`

###   

**Environment variable creation**

set elasticsearch.username = elastic

set elasticsearch.password = changeme

### Referring the environment variable

**Variable usage in yml**

elasticsearch.username: ${elasticsearch.username}  
elasticsearch.password: ${elasticsearch.password}


Component compatibility matrix
=================================

| API Gateway | Elasticsearch | Kibana | Filebeat |
| ----------- | ------------- | ------ | -------- |
| 10.1        | 2.3.2         | 4.5.1  | NA       |
| 10.2        | 5.6.4         | 5.6.4  | NA       |
| 10.3        | 5.6.4         | 5.6.4  | 6.0.1    |
| 10.4        | 5.6.4         | 5.6.9  | 6.0.1    |
| 10.5        | 7.2.0         | 7.2.0  | 7.2.0    |

Troubleshooting
===============

| Problem                                | Description                                                  | Resolution                                                   | Remarks                                                      |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Unknown secure setting while startup   | \[o.e.b.ElasticsearchUncaughtExceptionHandler\] \[\] uncaught exception in thread \[main\]<br/>org.elasticsearch.bootstrap.StartupException: java.lang.IllegalArgumentException: unknown secure setting \[tes\] please check that any required plugins are installed, or check the breaking changes documentation for removed settings<br/>Caused by: java.lang.IllegalArgumentException: unknown secure setting \[tes\] please check that any required plugins are installed, or check the breaking changes documentation for removed settings | Remove the unused settings from the keystore for a healthy startup |                                                              |
| bin/elasticsearch\-keystore list fails | Exception in thread "main" java.lang.SecurityException: Keystore has been corrupted or tampered with | Make sure that your setting does not have a upper case character. If yes, remove the setting and try again | After ES 6.2, this is validated properly. The tool will not allow to insert these keys |

References
==========

| Description                       | URL                                                          | Supported version | Comments |
| --------------------------------- | ------------------------------------------------------------ | ----------------- | -------- |
| Installig Xpack                   | https://www.elastic.co/guide/en/x-pack/5.6/installing-xpack.html | >5.6              |          |
| Secure string in Kibana           | [https://www.elastic.co/guide/en/kibana/current/secure-settings.html](https:/www.elastic.co/guide/en/kibana/current/secure-settings.html) |                   |          |
| FileBeat Configuration            | https://www.elastic.co/guide/en/beats/filebeat/6.0/filebeat-configuration.html | > 6.0             |          |
| Securing FileBeat                 | https://discuss.elastic.co/t/filebeat-best-way-to-secure-credentials/61704/17 |                   |          |
| Securing FileBeat                 | [https://www.elastic.co/guide/en/beats/filebeat/current/keystore.html](www.elastic.co/guide/en/beats/filebeat/current/keystore.html) | > 7.0             |          |
| Logstash keystore                 | [ https://www.elastic.co/guide/en/logstash/6.3/keystore.html](https://www.elastic.co/guide/en/logstash/6.3/keystore.html) | > 6.3             |          |
| X-pack settings support           | https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html | > 6.2             |          |
| Securing Elasticsearch with nginx | https://www.minvolai.com/setting-up-a-secure-single-node-elasticsearch-server-behind-nginx/ | > 2.x             |          |
