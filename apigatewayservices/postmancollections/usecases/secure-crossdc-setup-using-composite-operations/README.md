The requests in this collection can be executed in the sequence listed and they take care of:
* Composing the request payload with the configured crossdc_hosts variable
* Configuring the listener for the local data center and the ring.
* Activates the ring setup across all data centers with the configured mode.

This collection assumes that all the data centers use the same HTTP(S) port and GRPC port for communication, have the same username and password, use the same keystore, key and truststore aliases for the secure communication.

The following variables must be set for the request execution to be successful:
1. **protocol** - Possible values are http or https. The protocol that you wish to use in the request.
1. **domain** - The hostname of the machine where API Gateway is installed or a load balancer is hosted (if configured for API Gateway). 
1. **port** - The API Gateway Integration Server port (default value 5555) or the load balancer port (default is 80 or 443) depending on the configured value for domain. 
1. **username** - The username for establishing the connection for the request. The user should have \"Manage general administration configurations\" permission.
1. **password** - The password corresponding to the provided username
1. **crossdc_port** - A non-standard port (user-defined) number ranging from 1000 - 65535 that will be used to establish the GRPC communication between the data centers.
1. **crossdc_hosts** - A comma separated list of hostnames (load balancer or API Gateway) representing the data centers that will be participating in the cross DC setup.
1. **crossdc_mode** - Possible values are STANDALONE, STANDBY and ACTIVE_RING.
1. **crossdc_keystore_alias** - The alias of the keystore (that must be configured in the API Gateway) to be used for establishing the secure cross DC communication between data centers
1. **crossdc_key_alias** - The key alias from the provided keystore alias to be used for the secure communication.
1. **crossdc_truststore_alias** - The alias of the truststore (that must be configured in the API Gateway) to be used for verifying the identity of the data centers during the secure communication.
1. **crossdc_insecure_manager** - true if self-signed certificates are imported in the configured truststore. If only valid CA signed certificates are used in the truststore, then this can be set to false.

For example, assume the following are the hostnames of the data centers participating in the Cross DC setup:
1. eu.example.com
1. us.example.com
1. au.example.com

And if the request is going to be issued to eu.example.com, then the variables must be appropriately provided the following values:
domain=eu.example.com
crossdc_hosts=us.example.com,au.example.com
