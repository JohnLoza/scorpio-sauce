# Products

## api/products **GET Request**
get a list of products, optionally you can provide an `id` parameter
specifying an array of ids of products you would like to read

### **response**
```json
{
  "status": "completed",
  "data": [
    product_obj,
    product_obj,
    product_obj
  ]
}
```

## api/products/:id **GET Request**
Get the product data of a single product

### **response**
```json
{
  "status": "completed",
  "data": product_obj
}
```

## Product obj
```json
{
  "id": x,
  "name": "salsa scorpio 250ml",
  "price": 12.00,
  "half_wholesale_price": 10.00,
  "units_required_half_wholesale": 10,
  "wholesale_price": 8.00,
  "units_required_wholesale": 20
}
```
