<!-- Copyright 2013 - 2018 Software AG, Darmstadt, Germany and/or its licensors

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

# API Gateway cluster

Use this template to provision and maintain API Gateway cluster.

## Requirements and limitations

There should not be any other packages installed on the Integration Server or Microservices Runtime instance where API Gateway is running.

Before using this template, you must provision Terracotta cluster and Internal Data Store cluster by applying:
* [sag-tc-cluster](https://github.com/SoftwareAG/sagdevops-templates/tree/master/templates/sag-tc-cluster)
* [sag-internaldatastore](https://github.com/SoftwareAG/sagdevops-templates/tree/master/templates/sag-internaldatastore)

### Supported Software AG releases

* Command Central 10.3 and higher
* API Gateway with Integration Server 10.1 and higher
* API Gateway with Microservices Runtime 10.1 to 10.3
> NOTE: This template is not supported for Microservices Runtime version 10.4.

### Supported platforms

All supported Windows and UNIX platforms.

### Supported use cases

* Provisioning a new clustered environment containing Integration Server or Microservices Runtime instances with API Gateway 10.1 and higher
* Installing latest fixes
* Configuration of:
  * License
  * JVM memory
  * Primary, diagnostics, and JMX ports for Integration Server or Microservices Runtime
  * Clustered environment with Integration Server or Microservices Runtime

## Using the template to provisioning a new API Gateway Server instances and configure them in a cluster

For information about applying templates, see [Applying template using Command Central CLI](https://github.com/SoftwareAG/sagdevops-templates/wiki/Using-default-templates#applying-template-using-command-central-cli).

To provision a new Integration Server instance named "apigateway" with API Gateway 10.3, install all latest fixes, and configure the cluster:

```bash
sagcc exec templates composite apply sag-apigateway-cluster nodes=[dev1,dev2] \
  is.instance.type=integrationServer \
  agw.memory.max=512 \ 
  agw.tsa.url="dev1:9010" \
  repo.product=products-10.3 \
  repo.fix=fixes-10.3 \
  --sync-job --wait 360
```

To provision a new Microservices Runtime instance "apigateway" with API Gateway 10.3, install all latest fixes, and configure the cluster using default values:

```bash
sagcc exec templates composite apply sag-apigateway-cluster nodes=node \
  repo.product=products-10.3 \
  repo.fix=fixes-10.3 \
  --sync-job --wait 360
```
