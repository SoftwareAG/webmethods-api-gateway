# Helm chart for cluster deployment

## Usage

In order to setup an API Gateway cluster:

* download the chart from the [apigateway](apigateway) folder,
* follow the instructions in the [chart readme](apigateway/README.md) to provide Helm values,
* finally run `helm install my-helm-release apigateway -f my-values.yaml`.

By default the chart pulls these images:
* the API Gateway trial image from [Dockerhub](https://hub.docker.com/_/softwareag-apigateway),
* the open source images for ElasticSearch and Kibana from the [ElasticSearch Docker repository](https://www.docker.elastic.co/).

## Technical details

This section explains some technical details, in case it is intended to modify or extend the chart.

### Chart layout

The top level `apigateway` chart depends on the subchart `elasticsearchkibana` which encapsulates the Kubernetes
manifests for ElasticSearch/Kibana. With this separation it should be easier to exchange the setup
of one of the components if desired.

The top level chart can access values from the subcharts. In Helm this is achieved by prefixing the value's name from the subchart `values.yaml`
with the subchart name. For example, the API Gateway deployment addresses the ElasticSearch port as `.Values.elasticsearchkibana.elasticSearchPort`.

### License files

As described in the API Gateway [chart readme](apigateway/README.md) the license first of all needs to be provided as Kubernetes configmap.
The configmap is then used by a volume mapping to override the default license file location within the Docker image. Thus any
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

### Init containers

Both the API Gateway and the Kibana containers depend on ElasticSearch being ready. In order to achieve a smooth startup of the cluster as a
whole API Gateway and Kibana come with an init container. The init container basically has a sleep/retry loop that uses a simple curl command
to check whether ElasticSearch is ready. The init container will stop once ElasticSearch responds successfully.

### Access to the API Gateway cluster

By default, this chart establishes an Ingress to provide access to the API Gateway UI and runtime ports from outside the Kubernetes cluster.
The Ingress refers to services which in turn refer to the API Gateway pods. Due to the API Gateway UI requiring sticky sessions ([see also below](#sticky-ui-sessions)) the Ingress
is configured accordingly. However this default setup works only if the Kubernetes cluster runs with the wide-spread nginx-ingress controller which
can handle sticky sessions.

If the nginx-ingress controller is not present, or another ingress controller is preferred, an accordingly configured external load balancer can be used to
achieve sticky sessions. The chart can easily be switched to use a load balancer, for details see the [chart readme](apigateway/README.md).
When doing so, the chart will still establish an Ingress which then refers to the load balancer service, and the load balancer in turn is
configured as a proxy for the API Gateway services.

For the latter purpose the chart comes with an nginx deployment and appropriate configuration. Please note that API Gateway does not
rely on or prefer nginx. In order to use a different load balancer the chart needs to be adapted manually: replace the `nginx-*.yaml` files
in the [template folder](apigateway/templates) as desired, and keep in mind to configure the load balancer with sticky sessions for the
API Gateway UI port.

### Sticky UI sessions

The API Gateway web interface requires sticky sessions in order to function correctly. This is achieved by configuring the API Gateway service
for the UI port as well as the Ingress with sticky behaviour. The relevant parts of the service and the Ingress look like this:

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