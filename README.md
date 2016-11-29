# assignmnent_viking_analytics
Kelsey and Jeff
#WARMUPS
##1
```
SELECT username
FROM users
JOIN states
ON users.state_id = states.id
WHERE states.name = 'California'
```
##2
```
SELECT long_name
FROM airports
JOIN states
ON airports.state_id = states.id
WHERE states.name = 'Minnesota'
```
##3
```
SELECT payment_method
FROM itineraries
JOIN users
ON itineraries.user_id = users.id
WHERE users.email = 'heidenreich_kara@kunde.net'
```
But not sure about this one...
##4
```
SELECT price
FROM flights
JOIN airports
ON flights.origin_id = airports.id
WHERE airports.long_name = 'Kochfurt Probably International Airport'
```
##5
```
SELECT code, long_name
FROM airports
JOIN flights
ON airports.id = flights.destination_id
WHERE airports.code = 'LYT'
```
##6
```
SELECT long_name
FROM airports
JOIN flights
ON airports.id = flights.destination_id
WHERE flights.id IN (SELECT flight_id
FROM users
JOIN itineraries
ON users.id = itineraries.user_id
JOIN tickets
ON itineraries.id = tickets.itinerary_id
WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore')
```
#ADDING IN AGGREGATION
##1
```
SELECT price, destination_id
FROM flights
JOIN airports
ON destination_id = airports.id
JOIN states
ON airports.state_id = states.id
ORDER BY flights.price DESC
LIMIT 5
```
##2
```
SELECT distance, flights.id
FROM airports
JOIN flights
ON airports.id = flights.destination_id
WHERE flights.id IN (SELECT flight_id
FROM users
JOIN itineraries
ON users.id = itineraries.user_id
JOIN tickets
ON itineraries.id = tickets.itinerary_id
WHERE users.username = 'ryann_anderson')
ORDER BY flights.distance ASC
LIMIT 1
```
##3
```
SELECT cities.name, AVG(flights.distance) AS "Avg Distance"
FROM airports
JOIN states
ON airports.state_id = states.id
JOIN cities
ON airports.city_id = cities.id
JOIN flights
ON flights.origin_id = airports.id
WHERE states.name = 'Florida'
GROUP BY cities.name
```
##4
```
SELECT SUM(flights.price) AS "Flight Prices", users.username
FROM users
JOIN itineraries
ON users.id = itineraries.user_id
JOIN tickets
ON itineraries.id = tickets.itinerary_id
JOIN flights
ON tickets.flight_id = flights.id
GROUP BY users.username
ORDER BY "Flight Prices" DESC
LIMIT 3
```
##5
```
SELECT cities.name, COUNT(flights.id) AS "Flights In"
FROM airports
JOIN states
ON airports.state_id = states.id
JOIN cities
ON airports.city_id = cities.id
JOIN flights
ON flights.origin_id = airports.id OR flights.destination_id = airports.id
WHERE cities.name = 'Lake Vivienne' AND states.name <> 'Florida'
GROUP BY cities.name
```
##6
```
SELECT MAX(flights.distance) AS "Max Flight",
	   MIN(flights.distance) AS "Min Flight"
FROM flights
```

#ADVANCED

##1
```
SELECT COUNT(flights.destination_id) AS "Flight Count", cities.name
FROM users
JOIN itineraries
ON users.id = itineraries.user_id
JOIN tickets
ON itineraries.id = tickets.itinerary_id
JOIN flights
ON flights.id = tickets.flight_id
JOIN airports
ON flights.destination_id = airports.id
JOIN cities
ON airports.city_id = cities.id
WHERE users.state_id = 16
GROUP BY cities.name
ORDER BY "Flight Count" DESC
LIMIT 1
```
##2
```
SELECT COUNT(flights.id), flights.id
FROM flights
WHERE flights.departure_time IN (SELECT flights.arrival_time FROM flights)
AND flights.origin_id IN (SELECT flights.destination_id FROM flights)
GROUP BY flights.id
```
Did not finish

##3
```
SELECT MIN(flights.price) min_price, users.username
FROM users
JOIN itineraries
ON users.id = itineraries.user_id
JOIN tickets
ON tickets.itinerary_id = itineraries.id
JOIN flights
ON tickets.flight_id = flights.id
GROUP BY users.username
HAVING COUNT(itineraries.user_id) = 1
ORDER BY min_price
LIMIT 1
```

##4
```
SELECT AVG(flights.price) avg_price, states.name
FROM flights
JOIN airports
ON flights.destination_id = airports.id
JOIN tickets
ON tickets.flight_id = flights.id
JOIN itineraries
ON tickets.itinerary_id = itineraries.id
JOIN users
ON itineraries.user_id = users.id
JOIN states
ON users.state_id = states.id
GROUP BY states.name
ORDER BY states.name
```
Maybe as about this one

##5
```
SELECT MIN(flights.price) as cheapest_flight
flights.departure_time BETWEEN '2013-05-06 00:00:00.000000' AND '2013-06-18 00:00:00.000000'
flights.origin_id = --Oregon
WHERE flights.origin_id IN (SELECT flights.origin_id
FROM flights
JOIN airports
ON flights.origin_id = airports.id
JOIN states
ON airports.state_id = states.id
WHERE states.name = 'Oregon') AS out_of_ore AND
(SELECT flights.origin_id
FROM flights
JOIN airports
ON flights.origin_id = airports.id
JOIN states
ON airports.state_id = states.id
WHERE states.name = 'Pennsylvania') AS out_of_penn
(SELECT flights.destination_id
FROM flights
JOIN airports
ON flights.destination_id = airports.id
JOIN states
ON airports.state_id = states.id
WHERE states.name = 'Arkansas') AS into_ark
```
