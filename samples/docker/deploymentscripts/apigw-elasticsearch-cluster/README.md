# Running Clustered API Gateway Containers and Elasticsearch Containers

In this deployment scenario you can use the sample Docker Compose file apigw-elasticsearch-cluster.yml.

The following diagram depicts a set-up that has clustered API Gateway containers and Elasticsearch containers.

![APIGateway_cluster_and_externalES.png](../images/2.%20APIGateway_cluster_and_externalES.png)

To run clustered API Gateway containers and Elasticsearch containers

1. Set the environment variables to define image for the API Gateway Docker container and Terracotta as follows:

  ```
  export APIGW_DOCKER_IMAGE_NAME=image name or filepath location of an existing image
  export TERRACOTTA_DOCKER_IMAGE_NAME=terracotta image name
  ```
  
  The composite file requires an API Gateway Docker image. You can create the referenced image through API Gateway scripting. For details on creating a Docker image, see [API Gateway Docker Images](../../#api-gateway-docker-images).
  
  You can create the Terracotta image as follows:
  
  ```
  cd /opt/softwareag
  docker build --file Terracotta/docker/images/server/Dockerfile –tag is:tc
  ```
  
Specify the API Gateway image by changing the .env file. API Gateway uses the .env file when the working directory is .../samples/docker-compose, else you must specify the environment variables.

2. Run the following command to start Terracotta, clustered API Gateway, and Elasticsearch containers using the Docker Compose sample file:

  ```cd SAG-Root/IntegrationServer/instances/default/packages/WmAPIGateway/resources/samples/docker-compose
  docker-compose -f apigw-elasticsearch-cluster.yml up
  ```
  
  In the Docker Compose sample file apigw-elasticsearch-cluster.yml ensure that you have specified the required information such as image name, name and port of the Elasticsearch host, server port, and UI port. This creates and starts the containers. Run the `docker ps` command to view the details of the containers created.
  
To run it in the detached mode, append -d in the docker-compose command.

```
Note: You can stop the API Gateway Docker container and the Elasticsearch container using the Docker Compose sample file with the following command:
docker-compose -f apigw-elasticsearch-cluster.yml down
```
