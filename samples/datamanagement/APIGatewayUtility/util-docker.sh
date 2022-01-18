#!/bin/bash

export instanceName=default
# export SAG_HOME=C:/SoftwareAG1011july
# export JAVA_HOME=C:/SoftwareAG1011july/jvm/jvm

export SAG_HOME=/opt/softwareag
export JAVA_HOME=/opt/softwareag/jvm/jvm

if [ -z "$1" ]; then
    echo "No argument provided. Please provide the command followed by -c or -i. For example: -c list backup"
	echo "-c : Exit the container once command executed"
	echo "-i : Keeps running the container even after command executed"
else

	${JAVA_HOME}/bin/java -cp ${SAG_HOME}/IntegrationServer/instances/${instanceName}/packages/WmAPIGateway/bin/lib/apigateway-tools.jar com.softwareag.apigateway.tools.docker.ModifyExternalProperties ${instanceName}

	cd ${SAG_HOME}/IntegrationServer/instances/default/packages/WmAPIGateway/cli/bin

	if [ "$1" = "-i" ]; then
		./apigatewayUtil.sh "${@:2}"
		cd /
		./infinite.sh
	elif [ "$1" = "-c" ]; then
		./apigatewayUtil.sh "${@:2}"
	else
		echo "Please provide the command followed by -c or -i. For example: -c list backup"
		echo "-c : Exit the container once command executed"
		echo "-i : Keeps running the container even after command executed"
		./apigatewayUtil.sh -help
	fi
fi