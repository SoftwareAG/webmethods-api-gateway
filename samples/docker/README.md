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
