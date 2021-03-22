# Helm chart for cluster deployment

## Usage

In order to setup an API Gateway cluster:

* download the chart from the [apigateway](apigateway) folder,
* follow the instructions in the [chart readme](apigateway/README.md) to provide Helm values,
* finally run `helm install my-helm-release apigateway -f my-values.yaml`.

At the time of writing this article there is no prepared Docker image for the Terracotta BigMemory product.
Users need to create their own Docker image from an on-premise installation of Terracotta BigMemory by following the
product documentation. The Terracotta installation comes with a Dockerfile for this purpose.

Apart from that, the chart by default pulls the API Gateway trial image from [Dockerhub](https://hub.docker.com/_/softwareag-apigateway), and it pulls
open source images for ElasticSearch and Kibana from the [ElasticSearch Docker reposiory](https://www.docker.elastic.co/).

## Technical details

This section explains some technical details, in case it is intended to modify or extend the chart.

### Chart layout

The top level `apigateway` chart depends on the subcharts `elasticsearchkibana` and `terracotta` which encapsulate the Kubernetes
manifests for ElasticSearch/Kibana and Terracotta, respectively. With this separation it should be easier to exchange the setup
of one of the components if desired.

The top level chart can access values from the subcharts. In Helm this is achieved by prefixing the value's name from the subchart `values.yaml`
with the subchart name. For example, the API Gateway deployment addresses the Terracotta port as `.Values.terracotta.port`.

### License files

As described in the API Gateway [chart readme](apigateway/README.md) licenses first of all need to be provided as Kubernetes configmaps.
The configmaps are then used by volume mappings to override the default license file location within the Docker image. Thus any
existing default or trial license will be overwritten.

For example, it looks like this for the API Gateway license:

```
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - volumeMounts:
          - name: apigw-license
            mountPath: /opt/softwareag/IntegrationServer/instances/{{ .Values.global.integrationServerInstanceName }}/config/licenseKey.xml
            subPath:   licenseKey.xml
            readOnly:  false
      volumes:
      - name: apigw-license
        configMap:
          name: {{ .Values.apigwLicenseConfig }}
          defaultMode: 0666
          items:
          - key:  {{ .Values.apigwLicenseFilename }}
            path: licenseKey.xml
```

### API Gateway configuration

The API Gateway configuration is provided using externalized configuration files. The master configuration file `config-sources.yml` and the 
externalized configuration files are defined in a configmap, which in turn is referenced by a volume mapping which overrides the corresponding
default folder within the Docker image.

There is one exception to this: The Terracotta cluster name and cluster URLs are defined as environment variables directly inside the API Gateway
deployment.

### Init containers

Both the API Gateway and the Kibana containers depend on ElasticSearch being ready. In order to achieve a smooth startup of the cluster as a
whole API Gateway and Kibana come with an init container. The init container basically has a sleep/retry loop that uses a simple curl command
to check whether ElasticSearch is ready. The init container will stop once ElasticSearch responds successfully.

### Sticky UI sessions

The API Gateway web interface requires sticky sessions in order to function correctly. This is achieved by configuring the API Gateway service
for the UI port as well as the Ingress with sticky behaviour:

```
---
# apigateway-ui-svc.yaml
apiVersion: v1
kind: Service
spec:
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 1000
      
---
# apigateway-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:                                    
    nginx.ingress.kubernetes.io/affinity: "cookie"
```