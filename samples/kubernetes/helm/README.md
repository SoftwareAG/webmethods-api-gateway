# Simple deployment

The [simple-deployment](simple-deployment) folder provides a Helm chart that will startup API Gateway, possibly with multiple replicas.
Depending on chart value settings API Gateway will use an embedded ElasticSearch, a sidecar ElasticSearch, or refer to an external ElasticSearch.
The external ElasticSearch, as well as the Terracotta Server (needed in case of API Gateway clustering) are expected to be present, they will not
be started by the Helm chart.


# Peer-to-peer cluster deployment

Since version v10.11 API Gateways has the option to run as a peer-to-peer cluster, which in particular means there is no need to run
an additional Terracotta Server runtime. The [peer-to-peer-cluster-deployment](peer-to-peer-cluster-deployment) folder provides a Helm chart that will
startup an API Gateway peer-to-peer cluster together with an external ElasticSearch cluster, and a separate Kibana instance. The chart is supposed to provide a quick
start for trial and demo purposes, and it can of course also serve as a first step when setting up a production scenario.