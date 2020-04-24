# Externalized configuration samples

These files contain sample configuration for different flavors of starting API Gateway using externalized configurations. You can find the full details of configuration reference here http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Starting+API+Gateway+using+externalized+configurations.

### Usage of the configuration files

###### config-sources.yml

This is the master configuration file which contains the configuration source definitions.

###### apigw-elasticsearch-no-cluster.yml

Use this configuration to start API Gateway with

  * an external Elasticsearch
  * no cluster

###### apigw-elasticsearch-basicauth-no-cluster.yml

Use this configuration to start API Gateway with

  * an external Elasticsearch which is protected with basic authentication
  * no cluster

###### apigw-elasticsearch-ssl-no-cluster.yml

Use this configuration to start API Gateway with

  * an external Elasticsearch which is SSL protected
  * no cluster

###### apigw-elasticsearch-kibana-no-cluster.yml

Use this configuration to start API Gateway with

  * an external Elasticsearch
  * an external Kibana
  * no cluster

###### apigw-elasticsearch-kibana-cluster.yml

Use this configuration to start API Gateway with

  * an external Elasticsearch
  * an external Kibana
  * a Terracotta server array
  * an Elasticsearch cluster