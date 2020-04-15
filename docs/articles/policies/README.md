Topics on Policies in API Gateway
======================================================

This page contains articles explaining different policies in API Gateway. 

Request and Response policies in API Gateway 
---------------------------------------------

Despite the Invoke webMethods IS policy in API Gateway helps the API Provider to plugin custom logic, such as the transformation of request and response contents, in the mediation flow of an API, the newly introduced transformation policies in 10.2 provide a better and easy configuration of transformations based on conditions to a greater extent. The Provider doesn't need to create an IS service explicitly, instead, he can use the simple configurations provided in the transformation policies to achieve the same use cases. The conditions could be used to evaluate the values of the contents of request or response like headers, query parameters, path parameters, HTTP method, status code, status message and payload.This gives a hassle-free way of transforming content using the configurations provided in transformation policies. In this tutorial, we shall see how to conditionally transform the contents in a request and/or response, such as headers, query parameters, etc. using Request and Response Transformation policies. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Request%20and%20Response%20Transformation%20policies%20in%20API%20Gateway)**

Securing APIs Using 3rd party OAUTH2 Provider
---------------------------------------------

This tutorial helps to understand how a third party OAuth 2 identity provider and authorization server can be configured in API Gateway to secure the APIs using OAuth 2 authorization. Some of the providers who already provide this support are OKTA and PingFederate. In this case the API Gateway still remains as the Resource server. 

For 10.3 and above versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20APIs%20using%203rd%20party%20OAuth%202%20provider%20in%20API%20Gateway)**

For 10.2 and below versions, [**Read on...**](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20APIs%20using%20thirdparty%20OAuth2%20identity%20provider%20in%20API%20Gateway)

Securing APIs using OAuth 2 in API Gateway
------------------------------------------

OAuth 2 is an authorization framework that enables applications to obtain limited access to user accounts. It works by delegating user authentication to the service that hosts the user account, and authorizing third-party applications to access the user account. In this case, API Gateway acts as both Resource server and Authorization server. 

For 10.3 and above versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20APIs%20using%20OAuth%202%20in%20API%20Gateway)**

For 10.2 and below versions, [**Read on...**](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing+APIs+using+OAuth2+in+API+Gateway)

Securing APIs using JSON Web Token in API Gateway
-------------------------------------------------

JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. JWTs can be signed using a secret (with the HMAC algorithm) or a public/private key pair using RSA. In API Gateway, APIs can be enforced with JWT authentication and the authorization can be done based on the claims present in the JWT. 

For 10.3 and above versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20APIs%20using%20JSON%20Web%20Token%20in%20API%20Gateway)**

Securing API using Kerberos at the Message Level
------------------------------------------------

Kerberos is a network authentication protocol. It is designed to provide strong authentication for client/server applications by using secret-key cryptography. API Gateway can mandate the clients to add the kerberos token in the incoming SOAP request by using the "Inbound Authentication - Message" policy Action. If a native API is protected with Kerberos authentication at the message level API Gateway can use the "Outbound Authentication - Message" policy Action to add the kerberos token in the outgoing SOAP request. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Securing%20API%20using%20Kerberos%20at%20the%20Message%20Level)**

SAML Inbound and Outbound support
---------------------------------

This tutorial helps you to walk through the steps to enforce SAML Inbound and SAML Outbound authentication policies in API Gateway. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/SAML%20Inbound%20and%20Outbound%20support%20in%20API%20Gateway)**

Custom Extension policy
-----------------------

API Gateway provides different policies at different stages of the API flow which is sufficient enough for security, transformation, validation, error processing and monitoring. In addition to the existing policies, API Gateway now supports Custom Extension policy using which the customer can invoke their custom logic from API Gateway. This tutorial describes the details of different custom extension types that can be added to an API.   In this tutorial we will go through the various Custom Extension types and their usage in detail. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Custom%20Extension%20policy%20in%20API%20Gateway)**

Invoke webMethods IS policy
---------------------------

API Gateway ships with a number of mediation policies that are enough to accomplish most of the use cases in the API management world. But in some cases the API Provider wants to do some custom operation apart from the out of the box policy support. API Gateway helps to accomplish this by letting the Provider create a custom logic using IS services and configure them using the Invoke webmethods IS policy for an API. Among the many use cases, one important and demanding use case would be to read and transform the contents of a request or response in a webMethods IS service to implement the custom logic. In this tutorial, we shall see how to read and transform the contents from a request or response, such as headers, query parameters, path parameters, HTTP method, payload, status code, status message, etc using Invoke webMethods IS policy.

For 10.2 and above versions, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Invoke%20webMethods%20IS%20policy%20in%20API%20Gateway%2010.2)**

For 10.1 and below versions, [**Read on...**](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Invoke+webMethods+IS+policy+in+API+Gateway+10.1+and+below)

WSS Inbound policies in API Gateway
-----------------------------------

WS Security has been a popular way of securing SOAP APIs over the past. With the increased demand for securing SOAP APIs it is important for users of API Gateway to have a clear understanding on the usage of the above WS Security policies with API Gateway. This tutorial will give a brief explanation on the various WS Security policies in API Gateway and the different usecases behind them. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/WSS%20Inbound%20policies%20in%20API%20Gateway)**

Configure Outbound Authentication - Message Policy Action
---------------------------------------------------------

Using the "Outbound Authentication - Message" policy action , API Gateway can sign the outgoing SOAP message, encrypt the outgoing SOAP message, add X509 token to the SOAP message ,add username token to the SOAP message , add time stamp to the SOAP message, add kerberos token to the SOAP message, add SAML token to the SOAP message based on the web service security policies enforced at the native API. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Configure%20Outbound%20Authentication%20-%20Message%20Policy%20Action)**

SOAP over JMS
-------------

This tutorial is prepared to help understanding of JMS Inbound scenario and the policies associated with it, JMS Outbound scenario and the policies associated with it and the configurations required in Integration Server for the JMS policies. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/SOAP%20over%20JMS%20in%20API%20Gateway)**

Dynamic Routing
---------------

API Gateway routes the incoming request to the native service endpoint URL which is configured in the routing policies under Routing stage. While other routing policies support the configuration of static URL, there was no provision to dynamically modify the URL at runtime based on some parameters or custom logic. Dynamic routing policy enables API Providers to configure routing policy in such a way that, the routing endpoint can be dynamically modified using the value of a HTTP Header in the request or an IS Service to write Java code to apply some custom logic to dynamically modify the routing endpoint. With this policy in place the Provider has a strong control over the routing mechanism. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Dynamic%20Routing%20in%20API%20Gateway)**

Mobile Application Protection Filter
------------------------------------

Mobile Application Protection Filter enables the API-Gateway server to disable access for certain mobile application versions on a set of mobile devices. Filter ensures that all users are using the latest versions of the applications and taking advantage of the latest security and functional updates. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Mobile%20Application%20Protection%20Filter)**

SQL Injection Protection Filter
-------------------------------

SQL injection, also known as SQLI, is a common attack vector that uses malicious SQL code for back-end database manipulation to access information that was not intended to be displayed. This information may include any number of items, including sensitive company data, user lists or private customer details. The impact SQL injection can have on a business is far reaching. A successful attack may result in the unauthorised viewing of user lists, the deletion of entire tables and, in certain cases, the attacker gaining administrative rights to a database, all of which are highly detrimental to a business. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/SQL%20Injection%20Protection%20Filter)**

Message Size Filter
-------------------

Message size filter enables the webMethods API-Gateway server to reject or allow the incoming request based on size of the request. In some cases the native services may not have the capability of processing the incoming request of very large message size. For example, a request of 20mb chokes up the native service and makes it unavailable for other request to be handled. Message Size Filter comes in handy for preventing such scenarios. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Message%20Size%20Filter)**

Denial of Service
-----------------

On the Internet, a denial of service (DoS) attack is an incident in which an organization is deprived of the services of a resource and  and congesting it with useless traffic. Many DoS attacks, such as the Ping of Death and Teardrop attacks, exploit limitations in the TCP / IP protocols. To avoid this kind of attacks, API Gateway Threat Protection provides the capability of Denial of Service Protection. An administrator can configure the DOS protection to restrict the requests entering the system and thereby preventing the attackers from depleting the resources of the organization. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Denial%20of%20Service)**

Antivirus Scan Filter
---------------------

You can use the antivirus scan filter to configure webMethods API Gateway Server to interact with an Internet Content Adaptation Protocol (ICAP)-compliant server. An ICAP server is capable of hosting multiple services that you can use to implement features such as virus scanning or content filtering. Using the antivirus scan filter, webMethods API Gateway Server can leverage the ICAP protocol to scan all incoming HTTP requests and payload for viruses. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Antivirus%20Scan%20Filter)**

Threat Protection Dashboards
----------------------------

The Threat protection dashboards display a variety of charts to provide an overview of threat protection rules configured in API Gateway. To configure, **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Threat%20Protection%20Dashboards)**

Conditional error processing
----------------------------

API Gateway is capable of processing error message differently for different conditions. Error Processing in API Gateway means, based on a set of conditions construct or transform an error message that is to be sent to the client or allow the Native provider Fault response to be sent back as is. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Conditional%20error%20processing)**

XML Threat protection
---------------------

This tutorial explain how to configure XML threat protection rule in API Gateway.  Malicious attacks on XML applications typically involve large, recursive payloads, XPath/XSLT or SQL injections, and CData to overwhelm the parser and eventually crash the service. Applying XML threat protection in the API Gateway helps minimize the risk from such attacks by defining some limits on the structure. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/XML%20Threat%20protection)**

JSON Threat protection
----------------------

This tutorial explain how to configure JSON threat protection rule in API Gateway.  JavaScript object notation(JSON) is vulnerable to content level attacks. Such attacks attempt to use huge json files to overwhelm the parser and eventually crash the service.  Applying JSON threat protection in API Gateway helps minimize the risk from such attacks by defining few limits on the json structure. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/JSON%20Threat%20protection)**

Custom Threat protection Filter 
--------------------------------

You can use custom filter to invoke a service that is available on the webMethods API Gateway Server. You can use this capability to customize and invoke services in the webMethods API Gateway Server to perform actions such as custom authentication of external clients in the DMZ, logging or auditing in the DMZ, or implementation of custom rules for processing various payloads. Using the custom service implementation, you can extract the HTTP headers and payload from a request and act on it as per your business requirements. Upon processing the headers, you can forward the request to the internal server or deny the request and return an error message to the user. You can also use the pub.flow:setResponseHeaders and pub.flow:setResponseCode services to add custom headers to the response and to set customized response codes. **[Read on...](http://techcommunity.softwareag.com/pwiki/-/wiki/Main/Custom%20Filter)**


