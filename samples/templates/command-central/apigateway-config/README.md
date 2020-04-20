<!--
 Copyright (c) 2011-2019 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.

 SPDX-License-Identifier: Apache-2.0

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
# API Gateway server configuration

Use this template to configure API Gateway instance with external Elasticsearch, Kibana, Ports, Clustering and Logging configuration.

## Requirements and limitations

This template configures a single API Gateway server instance along with its other components. Before running this template, you should provision the required API Gateway instance. To provision an API Gateway server, you can use the [sag-apigateway-server](apigateway-server/) template. To provision an API Gateway cluster, you can use the [sag-apigateway-cluster](apigateway-cluster/) template.

### Supported Software AG releases

* Command Central 10.5 and higher
* API Gateway with Integration Server 10.5 and higher

### Supported platforms

All supported Windows and UNIX platforms.

### Supported use cases
* Configuration of:
  * External elastic search
  * Kibana
  * HTTP port
  * Cluster
  * Logging
  
### Using the template to configure an existing API Gateway instance

For information about applying templates, see [Applying template using Command Central CLI](https://github.com/SoftwareAG/sagdevops-templates/wiki/Using-default-templates#applying-template-using-command-central-cli).

To apply configurations to the API Gateway 10.5 instance installed on the `local` node:
```bash
sagcc exec templates composite apply sag-apigateway-config nodes=local \
  is.tenant=apigateway \
  es.ssl.user=admin es.ssl.password=admin es.hostname=daeyaimig102 es.port=9202 \
  kibana.host=vmyaibvt092 kibana.port=8492 \
  port.name="httpPort2" port.type=HTTPListener@6792 port.number=6792 port.description="Http Port on 6792" \
  cluster.name="APIGateway Cluster" cluster.terracottaurl=daeirnd33902:9612 \
  logger.mode=Debug \
  --sync-job --wait 360
```
