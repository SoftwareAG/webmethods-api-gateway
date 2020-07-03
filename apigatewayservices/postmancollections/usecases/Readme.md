# Use cases

API Gateway provides REST Services that can be used to perform transaction such as create, retrieve, update, and delete. Though you can easily perform through the UI, these operations involve numerous REST calls to be triggered from the backend.

The sample use cases included in this folder cover all transactions related to a particular functionality. Open the respective folder to view the sample use cases to perform all transactions of the corresponding functionality.

#### Postman Environment Variable

Retrieve the required variables and set it to postman environment variables for further use under tests tab.

```javascript
let apiResponse=JSON.parse(responseBody);
pm.environment.set("apiID", apiResponse.apiResponse.api.id);
```