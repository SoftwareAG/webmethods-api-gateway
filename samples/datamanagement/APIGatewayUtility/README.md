# Container support for API Gateway Utility using Docker

Backup and Restore operations in APIGateway are performed by running apigatewayUtil.bat script from the API Gateway installed location <install_dir>\IntegrationServer\instances\default\packages\WmAPIGateway\cli\bin. API Gateway Utility container does the similar thing, however it runs outside the APIGateway and we can run against any API Gateway environment on demand. Note: API Gateway's Elastic Search port has to be accessible for running this.

## Prerequisites for Building a Docker Image

* Install Docker client on the machine on which you are going to run API Gateway Utility and start Docker as a daemon. The Docker client should have connectivity to Docker server to create images.

## Build docker image

There are two ways to build your docker image for API Gateway Utility,

### Build docker image on top of default API Gateway image

1. Checkout this directory webmethods-api-gateway/samples/datamanagement/APIGatewayUtility/ in your local machine.

2. Run the below command to build the docker image

    ``` docker build . -t <tag_name> ```
	
	A sample command looks as follows:
	
	``` docker build . -t apigwutil ```

2. Verify the image gets lised with the name provided in above step

	``` docker image ls ```
	
### Build docker image on top of your locally installed API Gateway

First we have to create API Gateway image for locally installed API Gateway. To generate this image, Please refer this article - https://github.com/SoftwareAG/webmethods-api-gateway/tree/master/samples/docker

1. Once the API Gateway image is created by following the steps mentioned in the above article, Checkout this github directory webmethods-api-gateway/samples/datamanagement/APIGatewayUtility/ in your local machine. 

2. Edit the file 'Dockerfile' and replace the image name on the first line with the API Gateway image that you have created in the previous step.

	``` FROM [API_GATEWAY_IMAGE_NAME] ```
 
3. Run the below command to build the docker image

    ``` docker build . -t <tag_name> ```
	
	A sample command looks as follows:
	
	``` docker build . -t apigwutil ```
	
	
## Running the API Gateway Utility container

### Option 1: Exit the container after the command is executed

Start the API Gateway Utility image using the docker run command. Specify the elastic search host and port in the -e variable and -c followed by the command that is applicable for apigatewayUtil.

   ``` docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -c [COMMAND] ```
	
A sample command looks as follows:

   ```docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -c list backup```
	
### Option 2: Keep the container alive after the command is executed

Start the API Gateway Utility image using the docker run command:

    docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -i [COMMAND]
	
A sample command looks as follows:

    docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -i list backup
	
Enter into the container by using docker exec command:

	docker exec -it [CONTAINER_ID] /bin/bash
	
Go to /IntegrationServer/instances/default/packages/WmAPIGateway/cli/bin directory

	cd /opt/softwareag/IntegrationServer/instances/default/packages/WmAPIGateway/cli/bin
	
Execute any backup and restore command as follows:

	./apigatewayUtil.sh -help
Note: 

For secured Elastic Search, following environment variable has to be provided in the docker run command

        apigw_elasticsearch_hosts=host:port
	    apigw_elasticsearch_https_enabled=("true" or "false")
	    apigw_elasticsearch_http_username=user
	    apigw_elasticsearch_http_password=password
		
## Checking the API Gateway Utility logs

### Default log

Enter into the container by using docker exec command:

	 docker exec -it [CONTAINER_ID] /bin/bash
	
Go to /IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs directory

	 cd /opt/softwareag/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs

View APIGWUtility log file

	vi APIGWUtility.log

### Configure the log location	

Since this log file is present inside the container, this log file will be removed when we remove the container. If you want to persist the log file outside the container, then include the option -logFileLocation while executing the command. Sample given below,

	docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -c list backup -logFileLocation \utils\logs
	
Note: if we have mentioned -logFileLocation while executing the command, then logs will not stored in this default location - /IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs. Instead, logs will be saved under provided -logFileLocation.

### Console log

Message that is printed in the console while executing the command, will be saved under docker logs. To view the docker logs, execute below command

	docker logs [CONTAINER_ID]

## To view the help text or get the list of existing backup restore commands 

	docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -help

## Checking the exit code of the command

Run the following command to get the exit code of previous command,

For windows use, ``` echo %errorlevel% ```
For linux use,   ``` $? ```
