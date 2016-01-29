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
