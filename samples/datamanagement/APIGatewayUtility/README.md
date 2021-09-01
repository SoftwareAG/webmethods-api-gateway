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

	``` FROM [API_GATEWAY_IMAGE_NAME] ````
 
3. Run the below command to build the docker image

    ``` docker build . -t <tag_name> ```
	
	A sample command looks as follows:
	
	``` docker build . -t apigwutil ```
	
	
## Running the API Gateway Utility container

### Option 1: Exit the container after the command is executed

Start the API Gateway Utility image using the docker run command. Specify the elastic search host and port in the -e variable and -c followed by the command that is applicable for apigatewayUtil.

    ``` docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -c [COMMAND] ```
	
A sample command looks as follows:

	``` docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -c list backup ```
	
### Option 2: Keep the container alive after the command is executed

Start the API Gateway Utility image using the docker run command:

	``` docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -i [COMMAND] ```
	
A sample command looks as follows:

	``` docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -i list backup ```
	
Enter into the container by using docker exec command:

	``` docker exec -it [CONTAINER_ID] /bin/bash ```
	
Go to /IntegrationServer/instances/default/packages/WmAPIGateway/cli/bin directory

	``` cd /opt/softwareag/IntegrationServer/instances/default/packages/WmAPIGateway/cli/bin ```
	
Execute any backup and restore command as follows:

	``` ./apigatewayUtil.sh -help ```
Note: 

For secured Elastic Search, following environment variable has to be provided in the docker run command

    ``` apigw_elasticsearch_hosts=host:port
	    apigw_elasticsearch_https_enabled=("true" or "false")
	    apigw_elasticsearch_http_username=user
	    apigw_elasticsearch_http_password=password     ```
		
## Checking the API Gateway Utility logs

### Default log

Enter into the container by using docker exec command:

	``` docker exec -it [CONTAINER_ID] /bin/bash ```
	
Go to /IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs directory

	``` cd /opt/softwareag/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs ```

View APIGWUtility log file

	``` vi APIGWUtility.log ```

### Configure the log location	

Since this log file is present inside the container, this log file will be removed when we remove the container. If you want to persist the log file outside the container, then include the option -logFileLocation while executing the command. Sample given below,

	``` docker run -e apigw_elasticsearch_hosts=daeyaix1bvt01.eur.ad.sag:9240 apigwutil -c list backup -logFileLocation \utils\logs ```
	
Note: if we have mentioned -logFileLocation while executing the command, then logs will not stored in this default location - /IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs. Instead, logs will be saved under provided -logFileLocation.

### Console log

Message that is printed in the console while executing the command, will be saved under docker logs. To view the docker logs, execute below command

	``` docker logs [CONTAINER_ID] ```

## To view the help text or get the list of existing backup restore commands 

	``` docker run -e apigw_elasticsearch_hosts=[host:port] [IMAGE] -help ```

## Checking the exit code of the command

Run the following command to get the exit code of previous command,

For windows use, ``` echo %errorlevel% ```
For linux use,   ``` $? ```

## List of operations that we can perform with this container 

 COMMANDS LIST::
 -----------------------------------------------------------------------------
 configure manageRepo        Command to configure repository
    options
       -tenant               Specify tenant name (optional)
       -repoName             Specify repository name (optional)
       -file                 File path to read repository details (optional)
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 delete  manageRepo          Command to delete repository
    options
       -tenant               Specify tenant name (optional)
       -repoName             Specify repository name (optional)
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 list manageRepo             Command to list all repositories
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 create backup               Command to create backup
    options
       -tenant               Specify tenant name (optional)
       -repoName             Specify repository name (optional)
       -name                 Specify backup file name  (optional)
       -include              (optional) Specify one of the following backup type in case of partial backup:
                                1.'analytics' to backup runtime data
                                2.'assets' to backup assets.
                                3.'license' to backup license metrics
                                4.'audit' to backup audit logs
                                5.'log' to backup log data
                                Example partial backup: -include assets or -include assets,analytics
       -indices              Specify index name to backup particular index
                             Allows multiple value by comma separated or using wildcard (*)
                             Example: -indices gateway_default_apis,gateway_default_policy or -indices gateway*
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 list backup                 Command to list backup files in repository
    options
       -tenant               Specify tenant name  (optional)
       -repoName             Specify repository name (optional)
       -status               Specify to filter results based on status. Applicable values are SUCCESS, FAILED and IN_PROGRESS. Allows multiple value by comma separated
       -verbose              Specify true to view detailed output
       -format               Specify json/text to view verbose output in json or text format. Example: -verbose true -format json
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 delete backup               Command to delete the backup file
    options
       -tenant               Specify tenant name  (optional)
       -repoName             Specify repository name (optional)
       -name                 Specify backup file name. Either -name or -olderThan should be provided
       -olderThan            Specify to delete backups older than given number of days. Possible values: d(days)
                             Example: delete backup -olderThan 30d
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 restore backup              Command to restore the backup file
    options
       -tenant               Specify tenant name (optional)
       -repoName             Specify repository name (optional)
       -name                 Specify backup file name
       -sync                      Select true to make process synchronous, else select false to make it asynchronous. The default value is false. (optional)
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 status backup               Command to get the status of the backup file
    options
       -tenant               Specify tenant name (optional)
       -repoName             Specify repository name (optional)
       -name                 Specify backup file name
       -verbose              Specify true to view detailed output
       -format               Specify json/text to view verbose output in json or text format.
                             Example: -verbose true -format json
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 configure fs_path           -path c://sample//APIGATEWAY  Command to update Elasticsearch File system path
       -path                 File system location
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 perform open_indices        Command to open all indices of API Gateway in Elasticsearch
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 rollover index              Command to rollover
    options
       -type      specify the name of the alias to rollover. Only Events, logs and trace type alias supported.
                             Options:
                             1. performancemetrics       2. policyviolationevents   3. monitorevents     4. errorevents
                             5. threatprotectionevents   6. transactionalevents     7. lifecycleevents   8. auditlogs
                             9. log                      10. serverlogtrace         11. mediatortrace    12. requestresponsetrace
                             Example: rollover index -type monitorevents
       -tenant               Specify tenant name (optional)
       -targetIndexSuffix    specify the target index suffix (optional)
       -maxAge               specify the condition of max age (optional)
       -maxDocs              specify the condition of max documents (optional)
       -maxSize              specify the condition of max size (optional)
       -maxPrimaryShardSize  specify the condition of max primary shard size (optional)
       -dryRun               select true to execute dry run (optional)
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info

 export platformConfiguration        Command to export platform configuration
       -url                  specify the url
       -username             specify the username
       -password             specify the password (optional). If not provided, password is prompted via console.
       -filePath             specify the file system directory
       -logFileLocation      specify the file system location where logs needs to be saved. File name must end with '.log' extension (optional)
                             default location: "<install_dir>/IntegrationServer/instances/default/packages/WmAPIGateway/cli/logs/APIGWUtility.log"
       -logLevel             specify log level (optional). Default level is info