# assignmnent_viking_analytics

Bran Liang

## Queries 1: Warmups
### Get a list of all users in California
```sql
User.find_by_sql("
  SELECT users.username
  FROM users JOIN states ON users.state_id= states.id WHERE states.name = 'California' ")
```
### Get a list of all airports in Minnesota
```sql
User.find_by_sql("
  SELECT airports.long_name
  FROM airports JOIN states ON airports.state_id = states.id
  WHERE states.name = 'Minnesota'")
```
### Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```sql
User.find_by_sql("
  SELECT itineraries.payment_method
  FROM itineraries JOIN users ON itineraries.user_id = users.id
  WHERE users.email = 'heidenreich_kara@kunde.net'")
```
### Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```sql
User.find_by_sql("
  SELECT flights.price
  FROM flights JOIN airports ON flights.origin_id = airports.id
  WHERE airports.long_name = 'Kochfurt Probably International Airport'")
```
### Find a list of all Airport names and codes which connect to the airport coded LYT.
```sql
User.find_by_sql("
  SELECT airports.long_name AS name, airports.code FROM airports JOIN flights ON airports.id = flights.origin_id
  WHERE flights.destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'LYT')")
```
### Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
