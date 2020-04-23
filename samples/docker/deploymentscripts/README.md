# API Gateway docker deployment scripts

Use these deployment scripts (docker-compose) to deploy various flavors of API Gateway (standalone or cluster) and the dependent components like Elasticsearch, Kibana, Terracotta.

### Supported Software AG releases
* API Gateway 10.3 and above

### Supported platforms
All supported Windows and UNIX platforms.

### Supported use cases
* Deployment of
    * API Gateway standalone - single container
    * API Gateway cluster with three containers
    * Elasticsearch standalone - single container
    * Elasticsearch cluster with three containers
    * External kibana container
    * Terracotta container

### Usage of the deployment scripts

Use apigw-elasticsearch-cluster.yml to deploy  
  * an API Gateway cluster with three containers
  * an Elasticsearch cluster with three containers and 
  * a Terracotta container.

Use apigw-elasticsearch-cluster-kibana.yml to deploy  
  * an API Gateway cluster with three containers
  * an Elasticsearch cluster with three containers, 
  * an external Kibana container and 
  * a Terracotta container.
    
Use apigw-elasticsearch-no-cluster.yml to deploy
  * a single API Gateway container and 
  * a single Elasticsearch container.
    
The image names of API Gateway, Terracotta and Kibana can be altered by modifying the .env file when the file is in the working directory or by setting the environment variable APIGW_DOCKER_IMAGE_NAME, TERRACOTTA_DOCKER_IMAGE_NAME and KIBANA_DOCKER_IMAGE_NAME.
