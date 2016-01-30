# assignmnent_viking_analytics


Kit & Thomas
-- Queries 1: Warmups

-- 1
SELECT *
FROM users JOIN states ON state_id = states.id
WHERE name = 'California';

-- 2
SELECT *
FROM airports JOIN states ON state_id = states.id
WHERE name = 'Minnesota';

-- 3
select payment_method
FROM itineraries JOIN users ON users.id = user_id
WHERE email = 'payton_konopelski@jacobson.org';

-- 4
SELECT price
FROM flights JOIN airports ON origin_id = airports.id
WHERE long_name = 'New Marlinfurt Probably International Airport';

-- 5
SELECT origins.long_name, origins.code
FROM airports AS destinations JOIN flights ON destination_id = destinations.id
JOIN airports AS origins ON origin_id = origins.id
WHERE destinations.code = 'ULZ';

-- 6
SELECT DISTINCT long_name
FROM itineraries
JOIN users ON user_id = users.id
JOIN tickets ON itinerary_id = itineraries.id
JOIN flights ON flight_id = flights.id
JOIN airports ON airports.id IN (destination_id, origin_id)
WHERE first_name || ' ' || last_name LIKE 'Dannie D''Amore'
AND departure_time > '2012-01-01'

Queries 2:

--1
SELECT *
FROM airports JOIN states on state_id=states.id
JOIN flights ON destination_id=airports.id
WHERE name='California'
ORDER BY price DESC
LIMIT 5

--2
SELECT MIN(distance)
FROM users JOIN itineraries ON user_id=users.id
JOIN tickets ON itinerary_id=itineraries.id
JOIN flights on flight_id=flights.id
WHERE username='hoyt'

-- 4
SELECT first_name, last_name, SUM(price)
FROM users JOIN itineraries ON user_id = users.id
JOIN tickets ON itinerary_id = itineraries.id
JOIN flights ON flight_id = flights.id
WHERE CAST (departure_time AS VARCHAR) LIKE '2013%'
GROUP BY users.id
ORDER BY 3 DESC
LIMIT 3

-- 5

SELECT COUNT(*)
FROM cities JOIN airports ON city_id = cities.id
JOIN flights ON airports.id IN (destination_id, origin_id)
WHERE cities.name LIKE 'Lake Hollisfort'
AND NOT flights.id IN (
  SELECT flights.id
  FROM states JOIN airports ON state_id = states.id
  JOIN flights ON airports.id IN (destination_id)
  WHERE name = 'Florida'
)

-- 6
SELECT MAX(distance), MIN(distance)
FROM flights

Queries 3:

-- 1

SELECT destination_states.name, COUNT(*)
FROM users JOIN states AS home_states on users.state_id=home_states.id
JOIN itineraries ON user_id=users.id
JOIN tickets ON itinerary_id=itineraries.id
JOIN flights ON flight_id=flights.id
JOIN airports ON airports.id=destination_id
JOIN states AS destination_states ON airports.state_id=destination_states.id
WHERE home_states.name='California'
GROUP BY destination_states.name
ORDER BY 2 DESC

-- 2

SELECT origins.arrival_time, destinations.departure_time
FROM flights destinations JOIN flights origins ON destinations.origin_id=origins.destination_id
WHERE destinations.destination_id=origins.origin_id
AND origins.arrival_time < destinations.departure_time

--3

