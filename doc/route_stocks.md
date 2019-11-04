# Route Stock

## api/route_stocks/active **GET Request**
get the active route stock for the current user

### **response**
```json
{
  "status": "completed",
  "data": [
    {
      "product_id": 1,
      "batch": "ABCASSDA",
      "units": 50,
      "units_left": 45
    },
    {
      "product_id": 1,
      "batch": "HDDASDF",
      "units": 30,
      "units_left": 15
    },  
    {
      "product_id": 2,
      "batch": "BATCHAB",
      "units": 15,
      "units_left": 15
    }
  ]
}
```
