# Tickets

## api/tickets **GET Request**
List of available tickets

### **response**
```json
{
  "status": "completed",
  "data": {
    [
      ticket object,
      ticket object,
      ticket object
    ]
  } 
}
```

## api/tickets **POST Request**
create a new ticket  
requires the ticket params including the details of the ticket

### **response**
```json
{
  "status": "completed",
  "data": ticket_object
}
```

## api/tickets/:id **GET Request**
get the details of a given ticket

### **response**
```json
{
  "status": "completed",
  "data": ticket_object
}
```

## ticket params
```json
{
  "ticket":{
    "client_id": "1",
    "total": "803.00",
    "payment_method": "payment_method",
    "details": {
      "random_hash_key":{
        "product_id": "2",
        "units": "15",
        "batch": "19O23AFG",
        "sub_total": "203.00"
      },
      "random_hash_key":{
        "product_id": "3",
        "units": "15",
        "batch": "19O23BFG",
        "sub_total": "603.00"
      }
    }
  }
}
```
