# Clients
  every request requires an authentication token in 
  a 'Authorization' header

  sample curl request

    curl base_url/api/clients \
    -H "Content-Type: application/json" \
    -H "Authorization: auth_token"

  Every request that require an :id will return a 404 if the resource is not found

## /api/clients **GET Request**
  list of clients of the current user

### Response
    {
      status: "completed",
      data: {
        [
          client object,
          client object,
          client object
        ]
      } 
    }

## /api/clients **POST Request**
  creates a new client record and returns the client object

  requires the full client object, the billing object is optional

  responses:

    {
      status: "completed",
      data: {
        client object
      }
    }

    {
      status: "error",
      message: "CAN_NOT_SAVE_USER", 
      code:  3010, 
      errors: [
        "error_message",
        "error_message"
      ]
    }

## /api/clients/:id **GET Request**
  Asks for the information of the given client by id

  response: 

    {
      status: "completed",
      data: {
        client object
      }
    }

## /api/clients/:id **PATCH/PUT Request**
  Update an existing client by id and returns the client object

  requires the client object with the attributes to update

  response:

    {
      status: "completed",
      data: {
        client object
      }
    }

    {
      status: "error",
      message: "CAN_NOT_UPDATE_USER", 
      code: 3020, 
      errors: [
        "error_message",
        "error_message"
      ]
    }

## /api/clients/:id **DELETE Request**
  Delete an existing client by id and returns the client object

  response:

    {
      status: "completed",
      data: {
        client object
      }
    }

    {
      status: "error",
      message: "CAN_NOT_DELETE_USER", 
      code: 3020, 
      errors: [
        "error_message",
        "error_message"
      ]
    }

## Sample Client Object

    {
      user_id: 2,
      city_id: 20192,
      name: "Juan Carlos",
      address: "Bartolomé Gutiérrez #3130",
      colony: "Miravalle",
      zc: "44523",
      billing_data: billing object
    }

## Sample Billing Object

    {
      name: "Super y Farmacias Carlos Rivera",
      rfc: "ISJD283AJS",
      city_id: 20192,
      address: "Bartolomé Gutiérrez #3130",
      colony: "Miravalle",
      zc: "44523"
    }
