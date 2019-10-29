# Locations

## base_url/states **GET Request**
List of states

### Response
```json
[
  {"id":2526, "name":"Aguascalientes"},
  {"id":2527, "name":"Baja California"},
  {"id":2528, "name":"Baja California Sur"}
]
```

## base_url/cities **GET Request**
List of cities  
Requires **state_id** parameter

### Response
```json
[
  {"id":2526, "name":"Guadalajara"},
  {"id":2527, "name":"Zapopan"},
  {"id":2528, "name":"Tlaquepaque"}
]
```
