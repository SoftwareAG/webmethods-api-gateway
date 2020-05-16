## Deploying API Gateway Pod with API Gateway Containers having embedded elasticsearch

You can select this deployment model if you want API Gateway as a Kubernetes service protecting the native services deployed to Kubernetes. Here, API Gateway runs in dedicated pods, the API Gateway container has elasticsearch and kibana embedded. API Gateway routes the incoming API requests to the native services. The invocation of the native services by the consumers happens through APIs provisioned by API Gateway.

The below figure depicts the API Gateway Kubernetes service deployment model where you have a single API Gateway pod that contains API Gateway container with elasticsearch and kibana embedded. 

![single_pod_with_gateway_elasticsearch](../images/single_pod_with_gateway_elasticsearch.png)

Do the following steps to deploy API Gateway Kubernetes pod that contains elasticsearch embedded in API Gateway container
   
1. Run the following command to deploy API Gateway in the Kubernetes setup:

   ```
   kubectl create -f api-gateway-deployment-embedded-elasticsearch.yaml
   ```
   
   Ensure that you have specified the required information such as container name, the path to your API Gateway image stored in a docker registry and container port in the Kubernetes sample file [api-gateway-deployment-embedded-elasticsearch.yaml](api-gateway-deployment-embedded-elasticsearch.yaml). For details on Kubernetes YAML files, see Kubernetes documentation. 
   
   This now pulls the image specified and creates the API Gateway pod with API Gateway container in which Elasticsearch is embedded. 
   
Run the command `kubectl get pods` to view the pods created.

