Dariusz Biskupski
# assignmnent_viking_analytics

# Queries 1: Warmups

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





# Queries 2: Adding in Aggregation

1. Find the top 5 most expensive flights that end in California.
```
Airport.find_by_sql("
SELECT airlines.name, flights.id, flights.price FROM flights 
JOIN airports ON (flights.destination_id = airports.id)
JOIN airlines ON (flights.airline_id = airlines.id)
JOIN states ON (states.id = airports.state_id)
WHERE states.name='California'
ORDER BY flights.price DESC
LIMIT 5
")
```

2. Find the shortest flight that username "ryann_anderson" took.
```
Airport.find_by_sql("
SELECT * FROM flights 
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
WHERE users.username IN ('leopold')
AND flights.distance = (
SELECT MIN(flights.distance) FROM flights
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
WHERE users.username IN ('ryann_anderson'))
")
```

_or user from my seeds_

```
Airport.find_by_sql("
SELECT * FROM flights 
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
WHERE users.username IN ('leopold')
AND flights.distance = (
SELECT MIN(flights.distance) FROM flights
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
WHERE users.username IN ('leopold'))
")
```


3. Find the average flight distance for flights entering or leaving each city in Florida

```
Airport.find_by_sql("
SELECT AVG(flights.distance) FROM flights
JOIN airports airp_a ON (flights.destination_id = airp_a.id)
JOIN states state_a ON (state_a.id = airp_a.state_id)
JOIN airports airp_b ON (flights.origin_id = airp_b.id)
JOIN states state_b ON (state_b.id = airp_b.state_id)
WHERE state_a.name = 'Florida'
OR state_b.name = 'Florida'
")
```


4. Find the 3 users who spent the most money on flights in 2013

```
Airport.find_by_sql("
SELECT users.*, SUM(flights.price) total FROM users
JOIN itineraries ON (users.id = itineraries.user_id)
JOIN tickets ON (itineraries.id = tickets.itinerary_id)
JOIN flights ON (tickets.flight_id = flights.id)
WHERE flights.updated_at >= '2016-06-01' 
AND flights.updated_at <= '2017-05-31'
GROUP BY users.id
ORDER BY total DESC
LIMIT 3
")
```

5. Count all flights to or from the city of Lake Vivienne that did not land in Florida

```
Airport.find_by_sql("
SELECT COUNT(*) FROM flights
JOIN airports airp_a ON (flights.destination_id = airp_a.id)
JOIN cities city_a ON (city_a.id = airp_a.city_id)
JOIN states state_a ON (state_a.id = airp_a.state_id)
JOIN airports airp_b ON (flights.origin_id = airp_b.id)
JOIN cities city_b ON (city_b.id = airp_b.city_id)
JOIN states state_b ON (state_b.id = airp_b.state_id)
WHERE city_a.name = 'Lake Vivienne'
OR city_b.name = 'Lake Vivienne'
AND state_a.name != 'Florida'
")
```



6. Return the range of lengths of flights in the system(the maximum, and the minimum).

_(unclear if it's in time or distance, but according to aviation dictionary length of flight is defined as distance)_

```
Airport.find_by_sql("
SELECT MAX(flights.distance), MIN(flights.distance) FROM flights
")
```




# Queries 3: Advanced

1. Find the most popular travel destination for users who live in Kansas.
```
Airport.find_by_sql("
SELECT cities.name, COUNT(*) as sum FROM cities
JOIN flights ON (flights.destination_id = cities.id)
JOIN tickets ON (flights.id = tickets.id)
JOIN itineraries ON (itineraries.id = tickets.itinerary_id)
JOIN users ON (itineraries.user_id = users.id)
JOIN airports ON (flights.destination_id = airports.id)
JOIN states ON (states.id = users.state_id)
WHERE users.state_id = (
SELECT states.id FROM states
WHERE states.name = 'Kansas')
GROUP BY cities.name
ORDER BY sum DESC
LIMIT 2
")
```


2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.

How many flights have round trips possible? 
THat means connetions with airports where there exists 
a flight FROM that airport and a later flight TO that airport.


```
Flight.find_by_sql("
SELECT COUNT(*) FROM flights x
JOIN airports air_a ON air_a.id = x.origin_id
JOIN airports air_b ON air_b.id = x.destination_id
JOIN flights y ON air_b.id = y.origin_id
JOIN airports air_c ON air_c.id = y.destination_id
WHERE air_c.id = air_a.id
")
```



3. Find the cheapest flight that was taken by a user who only had one itinerary.

- find users who has only one itinerary
- sort by price
- Limit 1


```
User.find_by_sql("
SELECT flights.* FROM flights
JOIN tickets ON tickets.flight_id = flights.id
JOIN itineraries ON tickets.id = itineraries.user_id
JOIN users ON users.id = itineraries.user_id
WHERE users.id IN (SELECT users.id FROM users
JOIN itineraries ON users.id = itineraries.user_id
JOIN tickets ON tickets.id = itineraries.user_id
GROUP BY users.id
HAVING COUNT(*) = 1)
ORDER BY flights.price
LIMIT 1
")
```




4. Find the average cost of a flight itinerary for users in each state in 2012.

- find flights with origins per each states
- find AVG on price paid and group by state

```
User.find_by_sql("
SELECT AVG(flights.price), states.name FROM flights
JOIN tickets ON tickets.flight_id = flights.id
JOIN itineraries ON tickets.id = itineraries.user_id
JOIN users ON users.id = itineraries.user_id
JOIN airports ON flights.origin_id = airports.id
JOIN states ON states.id = airports.state_id
WHERE flights.updated_at < '2017-03-26'
GROUP BY states.name
")
```













