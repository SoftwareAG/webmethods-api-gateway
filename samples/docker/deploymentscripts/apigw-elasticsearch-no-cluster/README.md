# Running a Single API Gateway and an Elasticsearch Container

You can run a single API Gateway and an Elasticsearch container using Docker Compose. In this deployment scenario you can use the sample Docker Compose file `apigw-elasticsearch-no-cluster.yml`.

The following figure depicts an API Gateway container with an externalized Elasticsearch where Kibana is included in the API Gateway container.

![APIGateway_and_externalES.png](../images/1.%20APIGateway_and_externalES.png)

To deploy a single API Gateway and an Elasticsearch container, follow the below steps

1. Set the environment variables to define the image for the API Gateway container as follows:

  ```export APIGW_DOCKER_IMAGE_NAME=image name or filepath location of an existing image```
  
  The composite file requires an API Gateway Docker image. You can create the referenced image through API Gateway scripting. For details on creating a Docker image, see [API Gateway Docker Images](../#api-gateway-docker-images).
  
  The Docker Compose file references the standard Elasticsearch 7.2image: docker.elastic.co/elasticsearch/elasticsearch:7.2.0
  
  Specify the API Gateway image by changing the .env file. API Gateway uses the .env file when the working directory is .../samples/docker-compose, else you must specify the environment variables.

2. Run the following command to start the API Gateway Docker container and the Elasticsearch container using the Docker Compose sample file:

  ```
  cd SAG-Root/IntegrationServer/instances/default/packages/WmAPIGateway/resources/samples/docker-compose
  docker-compose -f apigw-elasticsearch-no-cluster.yml up
  ```
  
  In the Docker Compose sample file `apigw-elasticsearch-no-cluster.yml` ensure that you have specified the required information such as image name, name and port of the Elasticsearch host, server port, and UI port. This creates and starts the containers. Run the `docker ps` command to view the details of the containers created.
  
  To run it in the detached mode, append -d in the docker-compose command.
  ```
  Note: You can stop the API Gateway Docker container and the Elasticsearch container using the Docker Compose sample file with the following command:
  docker-compose -f apigw-elasticsearch-no-cluster.yml down
  ```
  
