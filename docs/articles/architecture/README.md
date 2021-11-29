Topics on Deployment and Architecture
==========================================================

This page provides you a number of articles on API Gateway deployment and architectural topics

API Gateway High Availability and Sizing
----------------------------------------

API Gateway can be setup for high availability and there are multiple deployment options. 

For details, refer to **[API Gateway Administration Guide](https://documentation.softwareag.com/webmethods/api_gateway/yai10-11/10-11_Api_Gateway_Administration_Guide.pdf).**

Elasticsearch Best Practices
----------------------------

API Gateway uses [Elasticsearch](https://www.elastic.co/products/elasticsearch) as its primary data store for persisting different types of data like APIs, Policies, Applications etc apart from runtime events and metrics.  Refer to **[API Gateway Administration Guide](https://documentation.softwareag.com/webmethods/api_gateway/yai10-11/10-11_Api_Gateway_Administration_Guide.pdf)** for details on topics such as Elasticsearch configuration, tuning, data management etc. 


Securing Elasticsearch for API Gateway
--------------------------------------

This tutorial helps to understand how the InternalDataStore (or a simple Elasticsearch instance) can be secured using Search Guard, an Elasticsearch plugin that offers encryption, authentication and authorization. In this context, this plugin helps to secure the EventDataStore by exposing it over HTTPS protocol and enabling a basic authentication by configuring users. 

For 10.11, **[Read on...](https://github.com/SoftwareAG/webmethods-api-gateway/tree/10.11/docs/articles/architecture/Securing-Elasticsearch-for-API-Gateway-10.11)**


Getting started with API Gateway DockerHub Image
------------------------------------------------

Software AG's webMethods API Gateway enables you to safely expose, monitor, monetize and manage your APIs for use in mobile, web and IoT applications.This brief tutorial describes how to get started with the API Gateway docker images from DockerHub. The API Gateway image available on DockerHub is a fully functional free trial version limited to 90 days for non-production use.  **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Getting%20Started%20with%20API%20Gateway%20DockerHub%20Image)**

API Gateway meets Openshift
---------------------------

The purpose of this tutorial is to show how the API Gateway v10.5 Docker image from DockerHub can be deployed on an OpenShift cluster. The API Gateway image available on DockerHub is a fully functional free trial version limited to 90 days for non-production use. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20Gateway%20meets%20OpenShift)** 

Blocking Requests to Internal Services in an API Gateway DMZ Deployment
-----------------------------------------------------------------------

webMethods API Gateway supports the safe exposure of APIs by featuring threat protection and enforcing identity and access management policies. Its reverse invoke capabilities supports the exposure of APIs that are running entirely behind a firewall or where just the service implementing the APIs is protected by a firewall.    This tutorial explains how to deploy an API Gateway to the DMZ that exposes APIs for webMethods flow services which are running on a webMethods Integration Server behind a firewall in the so called green zone. The focus is on making sure that no flow services of the internal Integration Server are exposed via the DMZ API Gateway. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Blocking%20Requests%20to%20Internal%20Services%20in%20an%20API%20Gateway%20DMZ%20Deployment)**

Configuring API Gateway using Command Central
---------------------------------------------

This tutorial helps to understand how a Command Central (CC) administrator can configure API Gateway from Command Central. **[Read on..](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configuring%20API%20Gateway%20using%20Command%20Central)**

Handling Clear text passwords
-----------------------------

API Gateway uses multiple external components for its various functionalities like persistence, dashboards,log aggregation etc .Some of the external components have config files containing the product related configurations which will be picked during startup. Passwords are also part of this configurations files and user should configure the secret in these configuration files as plain text. Any user who have the access to the file system can view the passwords and access these components and can tamper the data. Since they are external components, we don't have control over their configuration files and startup procedure to mask these secrets and hence we planned to utilize their obfuscation method/settings storage for hiding the passwords from the yaml files. **[Read on](https://github.com/SoftwareAG/webmethods-api-gateway/tree/master/docs/articles/architecture/handling-clear-text-passwords)...**

Support for Externalized Configurations
---------------------------------------

API Gateway can be provisioned using externalized configuration. 

For details, refer to **[API Gateway Administration Guide](https://documentation.softwareag.com/webmethods/api_gateway/yai10-11/10-11_Api_Gateway_Administration_Guide.pdf).**

Securing API Gateway and its Components using HTTPS
---------------------------------------------------

The API Management setup comprises various components, such as, API Gateway server, API Gateway UI, Elasticsearch, API Portal, Kibana, and Terracotta. You must create secure connections between these components in order to enable a secure channel of communication. For details, refer to **[API Gateway Administration Guide](https://documentation.softwareag.com/webmethods/api_gateway/yai10-11/10-11_Api_Gateway_Administration_Guide.pdf).**
