Topics on key features in API Gateway
==========================================================

This page provides a number of articles on key features in API Gateway.

Threat protection in API Gateway
--------------------------------

While the API Gateway comes with a rich set of API mediation policies such as Identification and Access control, request and response processing, traffic monitoring and different kinds of API routing rules it also provides a competent out of the box support for the threat protection rules and their configuration to protect the API Gateway and its APIs from the malicious attacks by the outsider. It also makes sure that even the native services inside the Integration server are kept safe.  In general, though there are lot of techniques and concepts we can talk about threat protection, this tutorial covers the details that help you understand how threat protection can be achieved in API Gateway. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Threat%20protection%20in%20API%20Gateway)**

API mocking in API Gateway
--------------------------

API Mocking is nothing but the imitation of real API. It simulates the behavior of real API but in a more controlled manner. Lets see a couple of scenarios where we need a mocking response for an API. Lets say in a typical product development, the back-end and UI development are happening in parallel. The UI developers need not to wait for a full fledged API instead they can work with the mock response and thus makes the UI development independent. Secondly, in a test-driven development, the testers need not to wait for the development completion of the APIs to start with their automation of tests rather they can automate all the tests with mock responses. Moreover the API Provider can expose the APIs to the clients before the actual implementation is done and provides the users with mock response in an agile manner. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20mocking%20in%20API%20Gateway)**

SOAP to REST Transformation
---------------------------

SOAP web services are commonly used to expose data within enterprises. With the rapid adoption of the REST APIs, it is now a necessity for API providers to have the ability to provide RESTful interfaces to their existing SOAP web services instead of creating new REST APIs. Using the API Gateway SOAP to REST transformation feature, the API provider can either expose the parts of the SOAP API or expose the complete SOAP API with RESTful interface. API Gateway allows you to customize the way the SOAP operations are exposed as REST resources. Additionally, the Swagger or RAML definitions can be generated for these REST interfaces. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/SOAP%20to%20REST%20Transformation)**

Teams in API Gateway
--------------------

Team support feature allows you to group the users who work in a project, or users with similar roles, as a team. Using this feature, you can assign assets for each team and specify the access level of team members based on the team members' project requirements. This feature is helpful for organizations that have multiple teams, who work on different projects. Users can access only the assets that are assigned to them. For example, consider an organization with different teams such as Development, Configuration Management, Product Analytics, and Quality Assurance. Each of these teams needs access to different assets at different levels. That is, developers would require APIs to develop applications and they require the necessary privileges to manage APIs and applications. Similarly, analysts would want the necessary privileges to view performance dashboards of assets. In such scenarios, you can group users based on their roles as a team and assign them the necessary privileges based on their responsibility. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Teams%20in%20APIGateway)**

API Mashups
-----------

In a typical microservices architecture, application is split into multiple services based on business functions or architectural decisions. The granularity of APIs provided by microservices is often different than what a client needs. Microservices typically provide fine-grained APIs, which means that applications need to interact with multiple services. In such cases, API gateway can provide a single entry point for all clients. The API gateway can handle requests in one of two ways. Some requests are simply proxied/routed to the appropriate service. It handles other requests by fanning out to multiple services by composing the individual microservices/APIs in to one mashed up API. This reduces the number of requests/round trips that the client application otherwise will have to make. 

For API Mashups in 10.3,  **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20Mashups%20in%20API%20Gateway)**

For API Mashups in 10.4 and above versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20Mashups%20in%20API%20Gateway%2010.4)**

AMQP 1.0 support in API Gateway
-------------------------------

Most of Java EE developers know that JMS is a standard Java API for communicating with Message Oriented  (MOM). As a matter of fact, JMS is a part of the Java EE which allows two different Java applications to communicate. Those applications could be JMS clients and yet kept being decoupled. It is considered to be robust and mature. Since JMS is part of Java EE, it is typically used when both client and servers are running in a JVM. What if client and server are using a different language or platform? AMQP comes to the rescue. AMQP - Advanced Message Queuing Protocol is an open source published standard for asynchronous messaging by wire. It enables encrypted and messaging between organizations and applications across multiple platforms. It can go P-2-P (One-2-One), publish/subscribe, and some more, in a manner of reliability and secured way. Some of the main features of AMQP are listed below.

*   Platform independent wire level messaging protocol
*   Consumer driven messaging
*   across multiple languages and platforms
*   It is the wire level protocol
*   Can achieve high performance
*   Supports long lived messaging
*   Has support for SASL and TLS

So here is why API Gateway needs AMQP support in addition to the JMS support. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/AMQP%201.0%20support%20in%20API%20Gateway)**

Staging, Promotion and DevOps of API Gateway assets
---------------------------------------------------

A typical enterprise-level customer separate their solution according to the different phases of the SDLC. The most common pattern is separation by development, QA and production stages. Promotion refers to the act of moving API Gateway artifacts from one stage to another. 

As each organization builds APIs using API Gateway for easy consumption and monetization, the continuous integration and delivery are integral part of the API Gateway solutions to get hold of the fast moving market. We need to automate the management of APIs and policies to speed up the deployment, introduce continuous integration concepts and place API artifacts under source code management. As new apps are deployed, the API definitions can change and those changes have to be propagated to other external products like API portal. This requires the API owner to update the associated documentation and in most cases this process is a tedious manual exercise. In order to address this issue, it is a key to bring in DevOps style automation to the API life cycle management process in API Gateway. With this, enterprises can deliver continuous innovation with speed and agility, ensuring that new updates and capabilities are automatically, efficiently and securely delivered to their developers and partners in a timely fashion and without manual intervention. This enables a team of API Gateway policy developers to work in parallel developing APIs and policies to be deployed as a single API Gateway configuration. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Staging%2C%20Promotion%20and%20DevOps%20of%20API%20Gateway%20assets)**

Websocket API in API Gateway
----------------------------

As we all know, with drastic changes and immense evolution of the internet, Websockets made a breakthrough and revolution in the client-server communication by providing a bidirectional, full-duplex communication between server and client over a single TCP connection. API Gateway, to be inline with this hot growing protocol's market, provides support for proxying Websocket APIs from 10.2 on wards. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Websocket%20API%20in%20API%20Gateway)**

Service registry support in API Gateway
---------------------------------------

Service registry is a catalog of services, which provides information on live endpoints of services. In micro-service architecture, the same service will be available in multiple locations as micro-services. A service registry stores the information of live endpoints of the services. When a client needs to send a request to a service, the service registry provides the information about the endpoint in which the service is live. API Gateway supports ServiceConsul and Eureka service registries. Both client side discovery and server side discovery of service registries are supported by API Gateway. This tutorial will guide you to configure service registries in API Gateway, to register/deregister API Gateway APIs to/from one or more service registries, and to configure the service registry in routing policy of an API in API Gateway, which enables us to discover an endpoint from service registry during run-time invocation of the API. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Service%20registry%20support%20in%20API%20Gateway)**

API Gateway and Microservice Runtime Integration using API Mashups
------------------------------------------------------------------

In this article, we will discuss how the lightweight container called webMethods Microservices Runtime helps us to host microservices you develop in Software AG Designer and use those microservices inside API Gateway for grouping services and exposing them as a single service. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20Gateway%20and%20Microservice%20Runtime%20Integration%20using%20API%20Mashups)**

Cumulocity integration with API Portal and API Gateway
------------------------------------------------------

The Cumulocity platform offers a rich set of APIs to manage devices, measurements and many other functions. With the help of "API Portal" and "API Gateway" those APIs can be safely exposed and managed for a full-featured API-based solution. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Cumulocity%20integration%20with%20API%20Portal%20and%20API%20Gateway)**

API Gateway and Trading Networks Integration
--------------------------------------------

Users can enable business-to-business communication between trading partners using Application Programming Interfaces (APIs). In addition to exchanging XML, EDI, flat files documents and so on, partners can invoke the exposed APIs to exchange information. These APIs are available by associating Trading Networks with a webMethods API Gateway instance. A partner can access the APIs that appear in the Partner Profiles and the associated Partner Groups pages. The API access key and the authentication mechanism to access the APIs also appear on the APIs tab of the Partner Profiles page. An Administrator can provide a user to view and edit permissions to add or delete the appearance of an API in the Partner Profiles page. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/API%20Gateway%20and%20Trading%20Networks%20Integration)**


Custom Destination - Splunk & AWS Lambda
--------------------------------------------
API Gateway supports different destinations, out of the box, to which one can publish events, performance metrics and audit log data.  In addition to the existing destinations, API Gateway now supports Custom Destinations using which the user can publish events, performance metrics and audit log data from API Gateway to destinations which are not supported out of the box. The tutorial shows how you can use custom destinations feature to push the data from API Gateway to Splunk and AWS Lambda function. **[Read on...](https://github.com/SoftwareAG/webmethods-api-gateway/tree/10.7/docs/articles/features/Custom%20Destinations)**



