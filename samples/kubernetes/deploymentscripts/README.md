# API Gateway kubernetes deployment scripts

Use these deployment scripts to deploy various flavors of API Gateway (standalone or cluster) and the dependent components like Elasticsearch, Kibana, Terracotta to a kubernetes cluster.

### Supported Software AG releases
* API Gateway 10.5 and above

### Supported platforms
All supported Windows and UNIX platforms.

### Sample use cases given
* Deployment of
    * API Gateway with an embedded elasticsearch
    * API Gateway with an elasticsearch as a sidecar container
    * API Gateway without elasticsearch (external elasticsearch running)   

### Usage of the deployment scripts

  * Use api-gateway-deployment-embedded-elasticsearch.yaml to deploy an API Gateway with an embedded elasticsearch to a kubernetes cluster
  * Use api-gateway-deployment-sidecar-elasticsearch.yaml to deploy an API Gateway with an elasticsearch as a sidecar container to a kubernetes cluster
  * Use api-gateway-deployment-external-elasticsearch.yaml to deploy API Gateway without elasticsearch to a kubernetes cluster. An external elasticsearch needs to be up and running for this.
