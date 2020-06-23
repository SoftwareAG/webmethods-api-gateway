# API with Scope Policy

#### Scope Policy

API Gateway will execute the policy actions in a sequence order during the API invocation. Instead of applying an policy action to the whole API we can restrict the execution to resource/method level. API Gateway provides such a support through Scope Policy.

In this use case we are going to create a Log Invocation policy action and associate it with a Scope policy. Then we are going to associate the scope policy with the API.

Let's see in detail

##### Step 1:

Create a API with the petstore URL

##### Step 2:

Get API Details by API ID

##### Step 3:

Create Log Invocation policy action

##### Step 4:

Create Scope policy with LMT

##### Step 5:

Update API with Scope policy. Specify the scope policy name at the resource/method level

##### Step 6:

Active the API

#### Output:

By running this postman collections using postman runner, we will get an API in activated state ready to be invoked with the above configurations.