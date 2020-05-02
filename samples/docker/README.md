# Docker
Docker is an open-source technology that allows users to deploy applications to software containers. A Docker container is an instance of a Docker image, where the Docker image is the application,
including the file system and runtime parameters.

You can create a Docker image from an installed and configured API Gateway instance and then run the Docker image as a Docker container. To facilitate running API Gateway in a Docker
container, API Gateway provides a script to use to build a Docker image and then load or push the resulting Docker image to a Docker registry.

Support for API Gateway with Docker 18 and later is available on Linux and UNIX systems for which Docker provides native support.

For details on Docker and container technology, see [Docker documentation](https://docs.docker.com)

## Docker security

Docker, by default, has introduced a number of security updates and features, which have made Docker easier to use in an enterprise. There are certain guidelines or best practices that apply to the following layers of the Docker technology stack, that an organization can look at:
* Docker image and registry configuration
* Docker container runtime configuration
* Host configuration

For detailed guidelines on security best practices, see the official Docker Security documentation at https://docs.docker.com/engine/security/security/.

Docker has also developed Docker Bench, a script that can test containers and their hosts' security configurations against a set of best practices provided by the Center for Internet Security. For details, see https://github.com/docker/docker-bench-security.

For details on how to establish a secure configuration baseline for the Docker Engine, see [Center for Information Security (CIS) Docker Benchmark](https://www.cisecurity.org/benchmark/docker/) (Docker CE 17.06).

For information on the potential security concerns associated with the use of containers and
recommendations for addressing these concerns, see [NIST SP 800](https://csrc.nist.gov/publications/sp800) publication (Application Container Security Guide)

## Building the Docker Image for an API Gateway Instance
The API Gateway Docker image provides an API Gateway installation. Depending on the existing installation the image provides a standard API Gateway or an advanced API Gateway. When running the image the API Gateway is started. The API Gateway image is created on top of an Integration Server image.

### Prerequisites for Building a Docker Image
Prior to building a Docker image for API Gateway, you must complete the following:
* Install Docker client on the machine on which you are going to install API Gateway and start Docker as a daemon. The Docker client should have connectivity to Docker server to create images.
* Install API Gateway, packages, and fixes on a Linux or UNIX system and then configure API Gateway and the hosted products.

### Building the Docker Image
To build a Docker image for an API Gateway instance, follow the below steps. Refer API Gateway Configuration Guide document for more information about how to provide the optional arguments.

1. Go to the <APIGateway_Installation>/IntegrationServer/docker directory

    ``` cd IntegrationServer/docker ```

2. Create a docker file for the Integration Server (IS) instance by running the following command:

    ``` ./is_container.sh createDockerfile [optional arguments] ```

3. Build the IS Docker image using the Docker file Dockerfile_IS by running the following command:

    ``` ./is_container.sh build [optional arguments] ```

4. Create a Docker file for the API Gateway instance from the IS image is:micro by running the following command:

    ``` ./apigw_container.sh createDockerfile [optional arguments] ```

    The Docker file is created under the root Integration Server installation directory.

5. Build the API Gateway Docker image using the core Docker file Dockerfile_IS_APIGW by running the following command:

    ``` ./apigw_container.sh build [optional arguments] ```


The image is stored on the Docker host. To check the image run the command 

` $ docker images `


The Docker images created using above steps feature the following:
* Docker logging. 

    API Gateway Docker containers log to stdout and stderr. The API Gateway logs can be fetched with Docker logs

* Docker health check

    API Gateway Docker containers perform health checks. You can use wget request against the API Gateway REST API to check the health status of API Gateway.

    Example: ``` HEALTHCHECK CMD curl http://localhost:5555/rest/apigateway/health ```

* Graceful shutdown.

    Docker stop issues a SIGTERM to the running API Gateway.

## Running the API Gateway Container
Start the API Gateway image using the docker run command:

``` docker run -d -p 5555:5555 -p 9072:9072 -name apigw is:apigw ```

The docker run is parameterized with the IS and the webApp port exposed by the Docker container. Follow the below section "Retrieving Port Information of the API Gateway Image" to get the port information from the API Gateway image.

The status of the Docker container can be determined by running the docker ps command:

``` docker ps ``` 

### Retrieving Port Information of the API Gateway Image
To retrieve the port information of the API Gateway image (is:apigw), run the following command:

``` docker inspect --format='{{range $p, $conf := .Config.ExposedPorts}} {{$p}} {{end}}' is:apigw ```

A sample output looks as follows:

``` 5555/tcp 9072/tcp 9999/tcp ```

### Stopping the API Gateway Container
Stop the API Gateway container using the docker stop command:

``` docker stop -t90 apigw ```

The docker stop is parameterized with the number of seconds required for a graceful shutdown of the API Gateway and the API Gateway Docker container name.

**Note**: The docker stop does not destroy the state of the API Gateway. On restarting the Docker container all assets that have been created or configured are available again.
