# API with Custom Extension

#### Custom Extension

API Gateway supports Custom Extension policy, using which the customer can invoke their custom logic from API Gateway.

In this use case we are going to add a Custom Extension policy to an API to call an external rest services. This can be done for many reasons, one of the use case is if the customer has their custom logic for authentication then they can use this.

Let's see in detail

##### Step 1:

Create a API with the petstore URL

##### Step 2:

Create External callout Custom Extension policy action

##### Step 3:

Get the policy details of the created API using the policy id

##### Step 4:

Associate created policy actions with API policy

##### Step 5:

Activate API

#### Output:

By running this postman collections using postman runner, we will get an API in activated state ready to be invoked with the above configurations.





