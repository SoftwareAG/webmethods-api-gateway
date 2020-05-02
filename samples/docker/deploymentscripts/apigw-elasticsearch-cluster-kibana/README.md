# Running Clustered API Gateway and Elasticsearch Containers and a Kibana Container

In this deployment scenario you can use the sample Docker Compose file apigw-elasticsearch-cluster-kibana.yml.

The figure depicts clustered API Gateway containers. They are talking to a clustered Terracotta Server Array container, a cluster of Elasticsearch container and an external Kibana.

![APIGateway_cluster_and_externalES_externalKibana.png](../images/3.%20APIGateway_cluster_and_externalES_externalKibana.png)

To run clustered API Gateway and Elasticsearch containers, and a Kibana container, follow the belowing steps.

1. Set the environment variables to define the API Gateway, Terracotta, and the Kibana image as follows:
  
  ```
  export APIGW_DOCKER_IMAGE_NAME=image name or filepath location of an existing image
  export TERRACOTTA_DOCKER_IMAGE_NAME=terracotta image name
  export KIBANA_DOCKER_IMAGE_NAME=kibana image name
  ```
  
  The composite file requires an API Gateway Docker image. You can create the referenced image through API Gateway scripting. For details on creating a Docker image, see [API Gateway Docker Images](../../#api-gateway-docker-images).
  
  You can create the Terracotta image as follows:
  
  ```
  cd /opt/softwareag
  docker build --file Terracotta/docker/images/server/Dockerfile –tag is:tc
  ```
  
  Specify the API Gateway image by changing the .env file. API Gateway uses the .env file when the working directory is .../samples/docker-compose, else you must specify the environment variables.

  API Gateway requires a customized Kibana image. The Docker file for creating the Kibana image is as follows:
  ```
  FROM centos:7
  COPY /opt/softwareag/profiles/IS_default/apigateway/dashboard /opt/softwareag/kibana
  EXPOSE 9405
  RUN chmod 777 /opt/softwareag/kibana/bin/kibana
  CMD /opt/softwareag/kibana/bin/kibana
  ```
  
2. Run the following command to start the API Gateway Docker container and the Elasticsearch container using the Docker Compose sample file:

  ```
  cd SAG-Root/IntegrationServer/instances/default/packages/WmAPIGateway/resources/samples/docker-compose
  docker-compose -f apigw-elasticsearch-cluster-kibana.yml up
  ```
  
  In the Docker Compose sample file apigw-elasticsearch-cluster-kibana.yml ensure that you have specified the required information such as image name, name and port of the Elasticsearch host, server port, UI port, and Kibana dashboard instance details. This creates and starts the containers. Run the `docker ps` command to view the details of the containers created.

  To run it in the detached mode, append -d in the docker-compose command.

  ```
  Note: You can stop the API Gateway Docker container and the Elasticsearch container using the
  docker-compose sample file with the following command:
  docker-compose -f apigw-elasticsearch-cluster-kibana.yml down
  ```
