# assignmnent_viking_analytics

Bran Liang

## Queries 1: Warmups
### Get a list of all users in California
```sql
User.find_by_sql("
  SELECT users.username
  FROM users JOIN states ON users.state_id= states.id WHERE states.name = 'California'
  ")
```
### Get a list of all airports in Minnesota
```sql
User.find_by_sql("
  SELECT airports.long_name
  FROM airports JOIN states ON airports.state_id = states.id
  WHERE states.name = 'Minnesota'
  ")
```
### Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```sql
User.find_by_sql("
  SELECT itineraries.payment_method
  FROM itineraries JOIN users ON itineraries.user_id = users.id
  WHERE users.email = 'heidenreich_kara@kunde.net'
  ")
```
### Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```sql
User.find_by_sql("
  SELECT flights.price
  FROM flights JOIN airports ON flights.origin_id = airports.id
  WHERE airports.long_name = 'Kochfurt Probably International Airport'
  ")
```
### Find a list of all Airport names and codes which connect to the airport coded LYT.
```sql
User.find_by_sql("
  SELECT Distinct airports.long_name AS name, airports.code FROM airports JOIN flights ON airports.id = flights.origin_id
  WHERE flights.destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'LYT')
  UNION
  SELECT Distinct airports.long_name AS name, airports.code FROM airports JOIN flights ON airports.id = flights.destination_id
  WHERE flights.origin_id = (SELECT airports.id FROM airports WHERE airports.code = 'LYT')
  ")
```
### Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
```sql
User.find_by_sql("
  SELECT DISTINCT airports.long_name, flights.departure_time FROM (tickets JOIN itineraries ON tickets.itinerary_id = itineraries.id)
  JOIN users ON itineraries.user_id = users.id
  JOIN flights ON tickets.flight_id = flights.id
  JOIN airports ON airports.id = flights.origin_id
  WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore' AND flights.departure_time > '2012-01-01'
  UNION
  SELECT DISTINCT airports.long_name, flights.departure_time FROM (tickets JOIN itineraries ON tickets.itinerary_id = itineraries.id)
  JOIN users ON itineraries.user_id = users.id
  JOIN flights ON tickets.flight_id = flights.id
  JOIN airports ON airports.id = flights.destination_id
  WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore' AND flights.departure_time > '2012-01-01'
  ")
```


## Queries 2: Adding in Aggregation
### Find the top 5 most expensive flights that end in California.
```sql
User.find_by_sql("
  SELECT flights.*
  FROM flights JOIN airports ON destination_id = airports.id
  JOIN states ON airports.state_id = states.id
  WHERE states.name = 'California'
  ORDER BY price DESC
  LIMIT 5
  ")
```
### Find the shortest flight that username "ryann_anderson" took.
```sql
User.find_by_sql("
  SELECT *
  FROM flights JOIN tickets ON flights.id = tickets.flight_id
  JOIN itineraries ON tickets.itinerary_id = itineraries.id
  JOIN users ON users.id = itineraries.user_id
  WHERE users.username = 'ryann[_]anderson'
  ORDER BY distance
  ")
```
### Find the average flight distance for flights entering or leaving each city in Florida
### Find the 3 users who spent the most money on flights in 2013
### Count all flights to or from the city of Lake Vivienne that did not land in Florida
### Return the range of lengths of flights in the system(the maximum, and the minimum).
