# Sessions

## /api/log_in **GET Request**
  requires the parameters **email** and **password**

### Responses
  when authentication is successful

    {
      status: "completed",
      data: {
        authentication_token: "auth_token"
      } 
    }

  when authentication is not successful due to incorrect email and/or password

    {
      status: "error",
      message: "AUTHORIZATION_ERROR",
      code: 1010
    }

# Other possible responses when authenticating
  the user has no rights to access the given resource
  
    {
      status: "error",
      message: "ACCESS_DENIED",
      code: 2010
    }

  the Authorization token is not present/not found

    {
      status: "error",
      message: "MISSING_AUTH_TOKEN",
      code: 1020
    }

  the Authorization token has expired

    {
      status: "error",
      message: "AUTH_TOKEN_EXPIRED",
      code: 1030
    }
