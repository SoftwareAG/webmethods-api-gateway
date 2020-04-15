Topics on Deployment and Architecture
==========================================================

This page provides you a number of articles on API Gateway deployment and architectural topics

API Gateway High Availability and Sizing
----------------------------------------

API Gateway can be setup for high availability and there are multiple deployment options. 

For versions <=10.4, **[Read on](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API+Gateway+High+Availability+and+Sizing)...**

For versions >= 10.5, **[Read on..](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20Gateway%20High%20Availability%20and%20Sizing%20for%2010.5).**

Elasticsearch Best Practices
----------------------------

API Gateway uses [Elasticsearch](https://www.elastic.co/products/elasticsearch) as its primary data store for persisting different types of data like APIs, Policies, Applications etc apart from runtime events and metrics. This document is intended to provide some basic guidelines for configuring and managing Elasticsearch. At different points in the document, we will provide the configurations/tunings details vis-a-vis API Gateway. Please note, though the information provided in this document would enable to you get started with the basic configurations, it is important that you refer to the official Elasticsearch documentation for completeness.

For versions <=10.4, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Elasticsearch%20best%20practices)** 

For versions >=10.5, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Elasticsearch%20best%20practices%20for%20API%20Gateway%2010.5)**

Securing Elasticsearch for API Gateway
--------------------------------------

This tutorial helps to understand how the EventDataStore (or a simple Elasticsearch instance) can be secured using Search Guard, an Elasticsearch plugin that offers encryption, authentication and authorization. In this context, this plugin helps to secure the EventDataStore by exposing it over HTTPS protocol and enabling a basic authentication by configuring users. 

For 10.4 and below versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20Elasticsearch%20for%20API%20Gateway%2010.2)**

For 10.5 and above versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20Elasticsearch%20for%20API%20Gateway%2010.5)**

Dismantling API Gateway
-----------------------

API Gateway bundles Kibana, dashboard and data visualization software and Elasticsearch, the primary datastore for APIs metadata, policies, events, metrics etc to get started with almost no configuration. But you might not want to have a Elasticsearch and a kibana instance for every API Gateway instance and you might want them to scale independently and there might be other cases when one would like to run them on independent nodes. In this tutorial let's see couple of deployment scenarios. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Dismantling%20API%20Gateway)**

Avoiding single point of failure for Elasticsearch in Kibana
------------------------------------------------------------

In a typical API Gateway deployment setup, Kibana can talk to only one Elasticsearch (IDS - Internal Data Store) at any point of time. Depending on your deployment topology, this could cause single point of failure. This document covers few variants which you can use depending on your tolerance levels. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Avoiding%20single%20point%20of%20failure%20for%20Elasticsearch%20in%20Kibana)**

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

API Gateway uses multiple external components for its various functionalities like persistence, dashboards,log aggregation etc .Some of the external components have config files containing the product related configurations which will be picked during startup. Passwords are also part of this configurations files and user should configure the secret in these configuration files as plain text. Any user who have the access to the file system can view the passwords and access these components and can tamper the data. Since they are external components, we don't have control over their configuration files and startup procedure to mask these secrets and hence we planned to utilize their obfuscation method/settings storage for hiding the passwords from the yaml files. **[Read on](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Handling+of+clear+text+passwords+in+external+components+of+API+Gateway)...**

Configure Reverse Invoke in webMethods API Gateway
--------------------------------------------------

This article mainly focuses on Configuration of Reverse Invoke communication between the API Gateway in the DMZ and webMethods Integration Server or API Gateway in the Internal Green zone. Explains in detail, how the API Gateway Administrator can configure the External and Registration Ports in webMethods API Gateway and Internal Ports in the API GW or IS internal server for the different deployment scenarios.  [**Read on...**](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configure%20Reverse%20Invoke%20in%20webMethods%20API%20Gateway)

Support for Externalized Configurations
---------------------------------------

The inter-component and cluster configurations of API Gateway are stored in different places within the product causing maintainability and operational overhead. Hence with this feature, the aforementioned configurations can be managed, provisioned from a central location supplied through one or more configuration files (YAML or Properties). This will help the API Gateway Administrator and operations teams to dynamically provision the API Gateway configurations enabling centralized configuration management, provisioning and scaling use cases. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Starting%20API%20Gateway%20using%20externalized%20configurations)**

Securing API Gateway and its Components using HTTPS
---------------------------------------------------

SSL creates a secure connection between servers and clients over the web and internal network, safeguarding sensitive data for secure transmission. The Hypertext Transfer Protocol Secure (HTTPS) is an internet communication protocol that protects the integrity and confidentiality of data between the user's computer and the site. The data sent over HTTPS is secured using SSL/TLS, which provides protection using encrypted channels.

The API Management setup comprises various components, such as, API Gateway server, API Gateway UI, Elasticsearch, API Portal, Kibana, and Terracotta. You must create secure connections between these components in order to enable a secure channel of communication. This article explains how to enable SSL support for the components of an API Management setup. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Full%20HTTPS%20Configuration%3A%20Securing%20API%20Gateway%20and%20its%20Components%20using%20HTTPS)**
