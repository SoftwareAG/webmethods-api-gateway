# API Gateway Cluster Helm Chart

This chart sets up an API Gateway cluster which by default consists of
* 3 API Gateway cluster nodes,
* an ElasticSearch cluster with 3 nodes,
* 2 Kibana nodes,
* 1 Ingress providing public access to the API Gateay UI and runtime ports.

The chart is organized as a top-level chart for API Gateway itself, and a subchart for
ElasticSearch/Kibana. The corresponding `values.yaml` files contain
default values where possible. In some cases there is no meaningful default, these values
need to be injected from outside, see the [Required Values](#required-values) section below.

Once the prerequisites are fulfilled and the required values as well as any optional values have been provided run helm:

```
helm install <your-release-name> apigateway -f my-values.yaml
```

# Prerequisites

## Licenses

API Gateway requires a license file. These license is supposed to be
provided as configmap.

Hence before running `helm install` create the configmap:

```
kubectl create configmap apigw-license-config --from-file=licenseKey.xml=<your path to API Gateway license file>
```

## Image Pull Secret

Provide an image pull secret for the registry where the desired images for API Gateway,
ElasticSearch, and Kibana are to be pulled from.

```
kubectl create secret docker-registry registry-credentials --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pwd> --docker-email=<your-email>
```

# Template Values

## Required Values

For some of the values needed by the chart there is no meaningful default. These values need to be provided
explicitly when running `helm install`, for example in a separate file `my-values.yaml`:

```
# my-values.yaml
k8sClusterSuffix:   " .. cluster suffix .. "
```

The cluster suffix must match the suffix of the URLs published by the Kubernetes cluster's Ingress Controller.
The suffix needs to start with a dot `.` character.

## Trial Usage

The charts are designed to provide a quick start for a trial evaluation or a product demo, as well as 
provide a basis for setting up a production environment.

The trial case (disabled by default) will often be run on a non-productive Kubernetes environment like
for example minikube, where persistent volumes are not always easily available. Therefore in trial mode,
ElastichSearch will be started without persistent volumes, which is good enough for the demo purpose.
Of course keep in mind that any data is lost once all ElastichSearch pods are shut down.

In order to enable trial mode:

```
# my-values.yaml
global:
  trialUsage:       true
```

Just make sure _not_ to quote the value, the chart expects a boolean value.

## Persistent Volume Claims

The persistent volume claims for ElastichSearch do not specify a storage class by default.
In order to specify a particular storage class:

```
# my-values.yaml
elasticsearchkibana:
  storageClassName:  "my-storage-class"
```

The persistent volume claims request 50GiB of disk storage by default, i.e., for each ElastichSearch pod.
In order to adapt the disk storage request:

```
# my-values.yaml
elasticsearchkibana:
  storageRequest:       100Gi
```

## Resource Requests and Limits

All pod containers come with default settings for resource requests and limits.
These can be adapted, for example:

```
# my-values.yaml
resources:  
  apigwContainer:
    requests:
      cpu: 500m
      memory: 4Gi
    limits:
      # use a high cpu limit to avaoid the container being throttled
      cpu: 8
      memory: 8Gi

elasticsearchkibana:      
  resources:
    esContainer:
      requests:
        cpu: 500m
        memory: 2Gi
      limits:
        # use a high cpu limit to avaoid the container being throttled
        cpu: 8
        memory: 4Gi
```

## Using an external load balancer

The Ingress provides two entrypoints for accessing the API Gateway cluster, one for the UI port to
allow access to the administration UI, and another one for the runtime port to allow for example REST access
to the services.

The API Gateway UI requires session stickiness and therefore both the Ingress and the Kubernetes
service in front of the API Gateway pods are correspondingly configured.

In some cases, typically if the nginx-ingress controller is not available in the Kubernetes system, the stickiness
settings are not correctly respected, and the API Gateway UI will not work. In particular the login to the UI
will fail.

This can be handled by using an external load balancer which is configured to use the API Gateway as
backend. And the Ingress is then defined against the load balancer service.

In order to enable the external load balancer:

```
# my-values.yaml
externalLoadBalancer:         true
```

Just make sure _not_ to quote the value, the chart expects a boolean value.

## Custom Prefix

If desired a custom prefix can be specified which will be applied to the names of deployments, statefulsets,
replica sets, pods, services, config maps, and ingresses.

Specify the custom prefix like this:

```
# my-values.yaml
global:
  customPrefix:     "myprefix"
```

Names will then look like this:

```
C:\>kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
myprefix-apigw-105-564f98cdcb-5wmwt   1/1     Running   0          20m
myprefix-apigw-105-564f98cdcb-9pf77   1/1     Running   0          20m
myprefix-apigw-105-564f98cdcb-w6684   1/1     Running   0          20m
myprefix-elasticsearch-ss-0           1/1     Running   0          20m
myprefix-elasticsearch-ss-1           1/1     Running   0          19m
myprefix-elasticsearch-ss-2           1/1     Running   0          19m
myprefix-kibana-ss-0                  1/1     Running   0          20m
```