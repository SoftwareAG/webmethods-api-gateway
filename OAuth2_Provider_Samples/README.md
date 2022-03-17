# Providers

OAuth 2.0 specification defines mechanisms for dynamically registering clients with authorization servers. The client registration request contains metadata about the client and the
response contains the client identifier. The clients can use this client identifier to communicate with the authorization server. There are some servers which deviates from the specification
and have their own way of registering clients. Providers can be created in APIGateway to handle those deviation from the specification.

## Prerequisites for using Providers

You must have the API Gateway's manage security configurations functional privilege assigned to add a provider. The OAuth 2.0 configuration in API Gateway is split into two sections - 
Providers and Authorization servers. You have to add a provider and configure the authorization provider metadata information for API Gateway to communicate with this  provider during dynamic client 
registration only. If there is any deviation from the actual OAuth specification then the provider has to be configured for these deviations.