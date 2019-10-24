# Sessions

## /api/sessions **POST Request**
  requires the parameters **email** and **password** encapsulated by **session**

    session: {
      email: "sample-email",
      password: "********"
    }

### Responses

    {
      status: "completed",
      data: {
        authentication_token: "auth_token"
      } 
    }

  Gives a 401 :unauthorized when authentication fails
