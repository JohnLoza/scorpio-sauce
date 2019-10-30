# Error types

## Authentication error **HTTP 401**
The api key provided in the request was invalid, or it did not have permissions to perform this request.

## Resource not found **HTTP 404**
The object on which you wished to perform this operation could not be found

## Parameter validation error **HTTP 422**
Some of the parameters in your request were missing or had invalid values

```json
{
  "status": "error",
  "message": "parameter_validation_error",
  "details": "error_reason"
}
```

## Resource could not be processed
The object on which you wished to perform this operation could not be processed,
see the errors section of the response for more details

```json
{
  "status": "error",
  "message": "unprocessable",
  "errors": [
    "error_message",
    "error_message"
  ]
}
```
