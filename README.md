# assignmnent_viking_analytics
*** Deepak

###1. Get a list of all users in California
```sql
User.find_by_sql("
  SELECT users.username
  FROM users JOIN states ON users.state_id = states.id
  WHERE states.name = 'California'
")
```
###2. Get a list of all airports in Minnesota
```sql
Airport.find_by_sql("
  SELECT airports.long_name
  FROM airports JOIN states ON airports.state_id = states.id
  WHERE states.name = 'Minnesota'
")
```
###3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```sql
Itinerary.find_by_sql("
  SELECT itineraries.payment_method
  FROM itineraries JOIN users ON itineraries.user_id = users.id
  WHERE users.email = 'heidenreich_kara@kunde.net'
")
```
###4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```sql
Flight.find_by_sql("
  SELECT flights.price
  FROM flights JOIN airports ON flights.origin_id = airports.id
  WHERE airports.long_name='Kochfurt Probably International Airport'
")
```

###5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```sql
Airport.find_by_sql("
  SELECT DISTINCT airports.long_name, airports.code
  FROM airports JOIN flights ON flights.destination_id = airports.id
  WHERE airports.code = 'LYT'
")
```
###6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
```sql
User.find_by_sql("
  select airports.long_name, flights.departure_time, flights.arrival_time
  FROM users JOIN itineraries ON users.id = itineraries.user_id
  JOIN tickets ON itineraries.id = tickets.itinerary_id
  JOIN flights ON tickets.flight_id = flights.id
  JOIN airports ON airports.id = flights.origin_id
  WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore' AND flights.departure_time > '2012-01-01'
  UNION
  select airports.long_name, flights.departure_time, flights.arrival_time
  FROM users JOIN itineraries ON users.id = itineraries.user_id
  JOIN tickets ON itineraries.id = tickets.itinerary_id
  JOIN flights ON tickets.flight_id = flights.id
  JOIN airports ON airports.id = flights.destination_id
  WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore' AND flights.departure_time > '2012-01-01'
")
```
