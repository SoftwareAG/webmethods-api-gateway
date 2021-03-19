# Simple deployment

The [simple-deployment](simple-deployment) folder provides a Helm chart that will startup API Gateway, possibly with multiple replicas.
Depending on chart value settings API Gateway will use an embedded ElasticSearch, a sidecar ElasticSearch, or refer to an external ElasticSearch.
The external ElasticSearch, as well as the Terracotta Server (needed in case of API Gateway clustering) are expected to be present, they will not
be started by the Helm chart.


# Cluster deployment

The [cluster-deployment](cluster-deployment) folder provides a Helm chart that will startup an API Gateway cluster together with an external
ElasticSearch cluster, a separate Kibana instance, and a Terracotta Server (active/passive setup). The chart is supposed to provide a quick
start for trial and demo purposed, and it can of course also serve as a first step when setting up production scenario.