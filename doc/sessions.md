# Sessions

## /api/sessions **POST Request**
Requires the parameters **email** and **password** encapsulated by **session**

```json
session: {
  email: "sample-email",
  password: "********"
}
```

### Responses
```json
{
  status: :completed,
  data: {
    authentication_token: "auth_token"
  } 
}
```

Gives a 401 :unauthorized when authentication fails
