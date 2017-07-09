# assignment_viking_analytics

Worked on by [Roy Chen](https://github.com/roychen25)

## Queries 1: Warmups

1. Get a list of all users in California
```
SELECT *
FROM users
WHERE users.state_id =
  (SELECT id FROM states WHERE states.name='California');
```
2. Get a list of all airports in Minnesota
```
SELECT *
FROM airports
WHERE state_id =
 (SELECT id FROM states WHERE name = 'Minnesota');
```
3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```
SELECT *
FROM itineraries
WHERE user_id =
  (SELECT id FROM users WHERE email = 'heidenreich_kara@kunde.net');
```
4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
SELECT *
FROM flights
WHERE origin_id =
  (SELECT id FROM airports WHERE long_name LIKE 'Kochfurt%');
```
5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```
SELECT DISTINCT long_name, code
FROM flights JOIN airports ON destination_id =
  (SELECT id FROM airports WHERE code = 'LYT')
```
6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
```
SELECT flights.arrival_time, airports.long_name
FROM tickets
JOIN itineraries ON (tickets.itinerary_id = itineraries.id)
JOIN flights ON (tickets.flight_id = flights.id)
JOIN airports ON (flights.destination_id = airports.id)
WHERE user_id =
  -- id for user
	(SELECT id
	FROM users
	WHERE first_name ='Dannie'
	AND last_name = 'D''Amore')
AND flights.arrival_time > '2012-01-01'
```

## Queries 2: Adding in Aggregation

1. Find the top 5 most expensive flights that end in California.
```
SELECT origin_id, destination_id, departure_time, arrival_time, CONCAT('$', price) AS price, airline_id
FROM flights
JOIN airports ON flights.destination_id = airports.id
JOIN states ON airports.state_id = states.id
WHERE states.id = (SELECT id FROM states WHERE name = 'California')
ORDER BY flights.price DESC
LIMIT 5
```
2. Find the shortest flight that username "ryann_anderson" took.
```
SELECT username, origin_id, destination_id, departure_time, arrival_time, price, distance
FROM tickets
JOIN itineraries ON tickets.itinerary_id = itineraries.id
JOIN flights ON tickets.flight_id = flights.id
JOIN users ON itineraries.user_id = users.id
WHERE users.username = 'ryann_anderson'
ORDER BY flights.distance ASC
LIMIT 1
--
-- alternatively, with an aggregate function
--
SELECT MIN(distance)
FROM tickets
JOIN itineraries ON tickets.itinerary_id = itineraries.id
JOIN flights ON tickets.flight_id = flights.id
JOIN users ON itineraries.user_id = users.id
WHERE users.username = 'ryann_anderson'
```
3. Find the average flight distance for flights entering or leaving each city in Florida
```
SELECT cities.name, AVG(distance)
FROM flights
JOIN airports ON (flights.origin_id = airports.id OR flights.destination_id = airports.id)
JOIN cities ON airports.city_id = cities.id
WHERE airports.state_id = (SELECT id FROM states WHERE name = 'Florida')
GROUP BY cities.name
```
4. Find the 3 users who spent the most money on flights in 2013
```
SELECT users.first_name, users.last_name, SUM(flights.price) AS total_spent
FROM tickets
JOIN itineraries ON tickets.itinerary_id = itineraries.id
JOIN flights ON tickets.flight_id = flights.id
JOIN users ON itineraries.user_id = users.id
WHERE flights.departure_time BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY users.first_name, users.last_name
ORDER BY total_spent DESC
LIMIT 3
```
5. Count all flights to or from the city of Lake Vivienne that did not land in Florida
```
WITH lake_vivienne AS (
	SELECT id
	FROM airports
	WHERE airports.city_id = (SELECT id FROM cities WHERE name = 'Lake Vivienne')
), florida_airports AS (
	SELECT id
	FROM airports
	WHERE airports.state_id = (SELECT id FROM states WHERE name = 'Florida')
)
SELECT COUNT(*)
FROM flights, lake_vivienne, florida_airports
WHERE flights.origin_id = lake_vivienne.id AND flights.destination_id != florida_airports.id
OR flights.origin_id != florida_airports.id AND flights.destination_id = lake_vivienne.id
```
6. Return the range of lengths of flights in the system (the maximum, and the minimum).
```
SELECT MIN(distance), MAX(distance), AVG(distance)
FROM flights
```
