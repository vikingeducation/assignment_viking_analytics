Dariusz Biskupski
# assignmnent_viking_analytics

#Queries 1: Warmups

1. Get a list of all users in California
```
User.find_by_sql("SELECT * FROM users JOIN states ON users.state_id = states.id WHERE name = 'California'")
```

2. Get a list of all airports in Minnesota
```
Airport.find_by_sql("SELECT * FROM airports JOIN states ON airports.state_id = states.id WHERE name = 'Minnesota'")
```

3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```
Itinerary.find_by_sql("SELECT itineraries.payment_method FROM itineraries JOIN users ON (itineraries.user_id=users.id) WHERE users.email='heidenreich_kara@kunde.net'")
```

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
Flight.find_by_sql("SELECT flights.price FROM flights JOIN airports ON (flights.origin_id = airports.id) WHERE airports.long_name='Kochfurt Probably International Airport'")
```

_another solution:_

```
Flight.find_by_sql("SELECT flights.price FROM flights JOIN airports ON (flights.origin_id = airports.id) WHERE airports.long_name ILIKE 'Angelicatown%'")
```

5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```
Airport.find_by_sql("SELECT airports.long_name, airports.code FROM airports JOIN flights ON (flights.origin_id = airports.id) WHERE flights.destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'LYT' )")
```

_or alternative to select from my seeded database_
```
Airport.find_by_sql("SELECT airports.long_name, airports.code FROM airports JOIN flights ON (flights.origin_id = airports.id) WHERE flights.destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'JUH' )")
```

6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
```
Airport.find_by_sql("
SELECT airports.long_name 
FROM airports JOIN flights ON (flights.origin_id = airports.id) 
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
WHERE users.first_name IN ('Dannie')
AND users.last_name IN ('D''Amore')
AND flights.updated_at > '2012-01-01'")
```
_or with my data:_

```
Airport.find_by_sql("
SELECT airports.long_name, flights.updated_at
FROM airports JOIN flights ON (flights.origin_id = airports.id) 
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
WHERE users.first_name IN ('Agnes')
AND users.last_name IN ('D''Amore')
AND flights.updated_at > '2012-01-01'")
```

