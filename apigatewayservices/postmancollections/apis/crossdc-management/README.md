The cross DC management collection offers the REST APIs to configure and setup cross DC. It defines the following variables, please ensure that they are set properly before executing the requests:
1. **protocol** - Possible values are http or https. The protocol that you wish to use in the request.
1. **domain** - The hostname of the machine where API Gateway is installed or a load balancer is hosted (if configured for API Gateway).
1. **port** - The API Gateway Integration Server port (default value 5555) or the load balancer port (default is 80 or 443) depending on the configured value for domain. 
1. **username** - The username for establishing the connection for the request. The user should have \"Manage general administration configurations\" permission.
1. **password** - The password corresponding to the provided username
1. **crossdc_port** - A non-standard port (user-defined) number ranging from 1000 - 65535 that will be used to establish the GRPC communication between the data centers.
1. **crossdc_keystore_alias** - The alias of the keystore (that must be configured in the API Gateway) to be used for establishing the secure cross DC communication between data centers
1. **crossdc_key_alias** - The key alias from the provided keystore alias to be used for the secure communication.
1. **crossdc_truststore_alias** - The alias of the truststore (that must be configured in the API Gateway) to be used for verifying the identity of the data centers during the secure communication.
1. **crossdc_insecure_manager** - true if self-signed certificates are imported in the configured truststore. If only valid CA signed certificates are used in the truststore, then this can be set to false.

It offers two methods to configure the setup:
1. **Basic operations**
	* This is configured for every data center. The sequence of steps must be executed on every data center in the cross DC setup.
1. **Composite Operations**
	* This is a composite operation request that should to be issued to only one of the data centers in the cross DC setup with metadata about the other data centers in the payload to establish the cross DC communication.