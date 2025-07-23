# Helm Charts for API Gateway

The Helm chart covers the following Kubernetes deployments for API Gateway:
* A pod with containers for API Gateway, Elasticsearch, and Kibana
* A pod with containers for API Gateway and Kibana
* A pod with containers for API Gateway and Kibana that supports clustering

The Helm chart supports a values.yaml file for the following Elasticsearch configurations:
* Embedded Elasticsearch
* External Elasticsearch
* Elasticsearch in a sidecar deployment

The [values.yaml](sag-apigateway/values.yaml) file passes the configuration parameters into the Helm chart. 
Provide the required parameters in this file to customize the deployment.

## Using Helm to Start the API Gateway Service

To use Helm chart to start the API Gateway service

1. Install and initialize Helm and then create a Helm chart.

For details, see [Helm documentaiton](https://github.com/helm/helm/blob/master/docs/quickstart.md#install-helm?).

This creates a standard layout with some basic templates and examples. Use the templates to
easily templatize your Kubernetes manifests. Use the set of configuration parameters that the
templates provide to customize your deployment.

2. Update the values.yaml file with the required information, such as the URL pointing to your
repository, the port and service details, and the deployment type for which you want to create
a service. The values.yml file passes the configuration parameters into the helm chart.

3. Navigate to the [working folder where the charts are stored](.), and run the following command.

```helm install sag-api-gateway```

where, sag-api-gateway is the Helm chart name.
The Kubernetes cluster starts API Gateway and the service.
