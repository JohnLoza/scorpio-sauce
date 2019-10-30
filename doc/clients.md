# Clients
Every request requires an authentication token in a 'Authorization' header  
Sample curl request

```bash
curl base_url/api/clients \
-H "Content-Type: application/json" \
-H "Authorization: auth_token"
```

Every request that require an :id will return a 404 if the resource is not found

## /api/clients **GET Request**
List of clients of the current user

### Response
```json
{
  status: :completed,
  data: {
    [
      client object,
      client object,
      client object
    ]
  } 
}
```

## /api/clients **POST Request**
Creates a new client record and returns the client object  
Requires the full client object, the billing object is optional

### Response
```json
{
  status: :completed,
  data: {
    client object
  }
}
```

## /api/clients/:id **GET Request**
Asks for the information of the given client by id

### Response
```json
{
  status: :completed,
  data: {
    client object
  }
}
```

## /api/clients/:id **PATCH/PUT Request**
Update an existing client by id and returns the client object  
Requires the client object with the attributes to update

### Response
```json
{
  status: :completed,
  data: {
    client object
  }
}
```

## /api/clients/:id **DELETE Request**
Delete an existing client by id and returns the client object

### Response
```json
{
  status: :completed
}
```

## /api/clients/locations **GET Request**
List of locations of all clients for the current user

### Response
```json
{
  status: :completed,
  data: [
    {
      name: "clients name",
      lat: "latitude",
      lng: "longitude"
    }
  ]
}
```

## Sample Client Object
```json
{
  id: 3
  name: "Juan Carlos",
  telephone: "33 1252 5342",
  address: "Bartolomé Gutiérrez #3130",
  colony: "Miravalle",
  zc: "44523",
  lat: "20.6170177",
  lng: "-103.3683971"
  billing_data: billing object
}
```

## Sample Billing Object
```json
{
  city_id: 20192,
  name: "Super y Farmacias Carlos Rivera",
  rfc: "ISJD283AJS",
  email: "email@sample.com",
  address: "Bartolomé Gutiérrez #3130",
  colony: "Miravalle",
  zc: "44523"
}
```
