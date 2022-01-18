# Container support for API Gateway Utility using Docker

Backup and Restore operations in APIGateway are performed by running apigatewayUtil.bat script from the API Gateway installed location <install_dir>\IntegrationServer\instances\default\packages\WmAPIGateway\cli\bin. API Gateway Utility container does the similar thing, however it runs outside the APIGateway and we can run against any API Gateway environment on demand.

> **Note:**
> This is applicable for API Gateway version 10.5 and above. If you are running against 10.7 environment, make sure to build the docker image on top of 10.7 base image.  API Gateway Elastic Search port has to be accessible for running this container.

## Prerequisites for Building a Docker Image

* Install Docker client on the machine on which you are going to run API Gateway Utility and start Docker as a daemon. The Docker client should have connectivity to Docker server to create images.

## Procedure

For example, if you want to create API Gateway backup using docker container then you will be following the below steps: 
* Build the docker image
* Run the docker container to create backup
* For troubleshooting, refer the logs

## Build docker image

There are two ways to build your docker image for API Gateway Utility,

### Build docker image on top of default API Gateway image 

In this case, we will be using the API Gateway trail image from DockerHub. We can also customize this image, details are given below.

1. Checkout this directory webmethods-api-gateway/samples/datamanagement/APIGatewayUtility/ in your local machine.

> **Note:** If you already have an API Gateway image and want to build the API Gateway Utility from this image then change the 'FROM' value to your API Gateway image name in the 'Dockerfile'. This Dockerfile can be found at checkout directory.
> 
> Update this value in the dockerfile >  FROM <api_gateway_image>

If you decide not to update dockerfile, then image will be build on top of API Gateway trail image from DockerHub. Please verify the version of API Gateway trail image.

2. Run the below command in the checkout directory from step 1 to build the docker image.
	
	
	docker build . -t <tag_name>

A sample command looks as follows:

	docker build . -t apigwutil

3. Verify the image gets lised with the name provided in above step


	 docker image ls
	
### Build docker image on top of your locally installed API Gateway

First we have to create API Gateway image for locally installed API Gateway. To generate this image, Please refer - **[API Gateway Configuration Guide](https://documentation.softwareag.com/webmethods/api_gateway/yai10-7/10-7_Api_Gateway_Configuration_Guide.pdf).**

1. Once the API Gateway image is created by following the steps mentioned in the above documentation, Checkout this github directory webmethods-api-gateway/samples/datamanagement/APIGatewayUtility/ in your local machine. 


2. In the checkout folder, edit the file 'Dockerfile' and replace the image name on the first line with the API Gateway image that you have created in the previous step.


	FROM [API_GATEWAY_IMAGE_NAME]

Modified dockerfile for example,

	FROM iregistry.eur.ad.sag/api-management/apigateway-dev:qa105
	COPY --chown=755:755 util-docker.sh /util-docker.sh
	COPY --chown=755:755 infinite.sh /infinite.sh 
	ENTRYPOINT ["./util-docker.sh"]
 
3. Run the below command in the checkout directory to build the docker image


    docker build . -t <tag_name>
	
A sample command looks as follows:
	
	 docker build . -t apigwutil
	
	
## Running the API Gateway Utility container

### Option 1: Exit the container after the command is executed

Start the API Gateway Utility image using the docker run command. Specify the elastic search host and port in the -e variable and -c followed by the command that is applicable for apigatewayUtil.

	docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -c [COMMAND]
	
A sample command looks as follows:

	docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -c list backup
	
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

### Console log

Message that is printed in the console while executing the command, will be saved under docker logs. To view the docker logs, execute below command

	docker logs [CONTAINER_ID]

### Default log

> **Note:** This option is applicable for only 10.11 and above

Enter into the container by using docker exec command:

	docker exec -it [CONTAINER_ID] /bin/bash
	
Go to /IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs directory

	cd /opt/softwareag/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs

View APIGWUtility log file

	vi APIGWUtility.log

### Configure the log location	

> **Note:** This option is applicable for only 10.11 and above

Since this log file is present inside the container, this log file will be removed when we remove the container. If you want to persist the log file outside the container, then include the option -logFileLocation while executing the command. Sample given below,

	docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -c list backup -logFileLocation \utils\logs
	
Note: if we have mentioned -logFileLocation while executing the command, then logs will not stored in this default location - /IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs. Instead, logs will be saved under provided -logFileLocation.

## To view the help text or get the list of existing backup restore commands 

	docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -help

## Checking the exit code of the command in 10.11 and above

Run the following command to get the exit code of previous command,

For windows use, ``` echo %errorlevel% ```
For linux use,   ``` $? ```
