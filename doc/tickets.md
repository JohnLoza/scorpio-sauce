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

## api/tickets/:id **PUT Request**
update ticket

### **required params**
```json
{
  "ticket": {
    "invoice_required": "0 or 1",
    "cfdi": "cfdi",
    "payment_method": "payment method"
  }
}
```

### **response**
```json
{
  "status": "completed",
  "data": ticket_object
}
```

## api/tickets/:id **DELETE Request**
cancel the ticket

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
    "total": "805.00",
    "invoice_required": "optional for creation DEFAULT is false",
    "payment_method": "payment_method",
    "cfdi": "optional DEFAULT is null",
    "details": [
      {
        "product_id": "2",
        "units": "15",
        "batch": "19O23AFG",
        "sub_total": "202.50"
      },
      {
        "product_id": "3",
        "units": "15",
        "batch": "19O23BFG",
        "sub_total": "602.50"
      }
    ]
  }
}
```
