# Use cases

API Gateway exposes rest services which is used to do atomic operations in API Gateway such as Create, Retrieve, Update, and Delete. 

Creating an API from API Gateway looks easy with the UI. But the process consist of multiple rest calls that is orchestrated at the backend.

Use cases consist of such type of orchestration which will enable the customer to automate different types of processes.

#### Postman Environment Variable

Retrieve the required variables and set it to postman environment variables for further use under tests tab.

```javascript
let apiResponse=JSON.parse(responseBody);
pm.environment.set("apiID", apiResponse.apiResponse.api.id);
```

