# API Gateway kubernetes deployment

The following sections describe in detail different deployment models for API Gateway as a Kubernetes service. Each of the deployment models described require an existing Kubernetes environment. For details on setting up of a Kubernetes environment, see [Kubernetes documentation](https://kubernetes.io/docs/home/)

With the API Gateway Kubernetes support, you can deploy API Gateway in one of the following ways:
* A pod with API Gateway container having embedded elasticsearch. [Read on ...](apigw-embedded-elasticsearch)
* A pod with API Gateway container and an Elasticsearch container. (Sidecar deployment) [Read on ...](apigw-sidecar-elasticsearch)
* A pod with API Gateway container connected to an Elasticsearch Kubernetes service. [Read on ...](apigw-external-elasticsearch)
