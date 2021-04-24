The requests in this collection can be executed in the sequence observed and they take care of:
* Obtaining the node name for the current host
* Configuring the listener for the local data center with the obtained node name
* Obtains the node name for every remote data center provided
* Configures the ring using the node names and host names
* Activates the ring setup with the configured mode.

This collection assumes that all the data centers use the same HTTP(S) port and GRPC port for communication and have the same username and password.

The following variables must be set for the request execution to be successful:
1. **protocol** - Possible values are http or https. The protocol that you wish to use in the request.
1. **domain** - The hostname of the machine where API Gateway is installed or a load balancer is hosted (if configured for API Gateway). 
1. **port** - The API Gateway Integration Server port (default value 5555) or the load balancer port (default is 80 or 443) depending on the configured value for domain. 
1. **username** - The username for establishing the connection for the request. The user should have "Manage general administration configurations" permission.
1. **password** - The password corresponding to the provided username
1. **crossdc_port** - A non-standard port (user-defined) number ranging from 1000 - 65535 that will be used to establish the GRPC communication between the data centers.
1. **crossdc_hosts** - A comma separated list of hostnames (load balancer or API Gateway) representing the data centers that will be participating in the cross DC setup.
1. **crossdc_mode** - Possible values are STANDALONE, STANDBY and ACTIVE_RING.

For example, assume the following are the hostnames of the data centers participating in the Cross DC setup:
1. eu.example.com
1. us.example.com
1. au.example.com

And if the request is going to be issued to eu.example.com, then the variables must be appropriately provided the following values:
domain=eu.example.com
crossdc_hosts=us.example.com,au.example.com
