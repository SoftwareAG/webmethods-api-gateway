# Kubernetes 
API Gateway can be run within a Kubernetes (k8s) environment. Kubernetes provides a platform for automating deployment, scaling and operations of services. The basic scheduling unit in Kubernetes is a pod. It adds a higher level of abstraction by grouping containerized components. A pod consists of one or more containers that are co-located on the host machine and can share resources. A Kubernetes service is a set of pods that work together, such as one tier of a multi-tier application.

The API Gateway Kubernetes support provides the following:
* Liveliness check to support Kubernetes pod lifecycle.

    This helps in verifying that the API Gateway container is up and responding.

* Readiness check to support Kubernetes pod lifecycle.

    This helps in verifying that the API Gateway container is ready to serve requests. For details
on pod lifecycle, see [Kubernetes documentation](https://kubernetes.io/docs/home/)

* Prometheus metrics to support the monitoring of API Gateway pods.

    API Gateway support is based on the Microservices Runtime Prometheus support. You use
the IS metrics endpoint /metrics to gather the required metrics. When the metrics endpoint is
called, Microservices Runtime gathers metrics and returns the data in a Prometheus format.
Prometheus is an open source monitoring and alerting toolkit, which is frequently used for
monitoring containers. 
