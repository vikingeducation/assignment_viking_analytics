-- 1. Find the top 5 most expensive flights that end in California.
SELECT CONCAT(origin.long_name, ' -> ', destination.long_name) AS flight, flights.price, states.name AS state  FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states ON states.id = destination.state_id
  WHERE states.name = 'California'
  ORDER BY price DESC
;

-- 2. Find the shortest flight that username "zora_johnson" took.
SELECT
  users.username AS username,
  CONCAT(origin.long_name, ' -> ', destination.long_name) AS flight,
  MIN(flights.arrival_time - flights.departure_time) AS flight_time
  FROM tickets
  JOIN itineraries ON itineraries.id = tickets.itinerary_id
  JOIN flights ON flights.id = tickets.flight_id
  JOIN users ON users.id = itineraries.user_id
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  WHERE username = 'zora_johnson'
  GROUP BY username, flight
;

-- 3. Find the average flight distance for every city in California
SELECT destination_state.name AS state, cities.name AS city, AVG(flights.distance) AS average_distance FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states origin_state ON origin_state.id = origin.state_id
  JOIN states destination_state ON destination_state.id = destination.state_id
  JOIN cities ON cities.id = destination.city_id
  WHERE destination_state.name = 'California'
  GROUP BY state, city
;

-- 4. Find the 3 users who spent the most money on flights in 2013
SELECT users.username, SUM(flights.price) AS total_money FROM flights
  JOIN tickets ON flights.id = tickets.flight_id
  JOIN itineraries ON itineraries.id = tickets.itinerary_id
  JOIN users ON users.id = itineraries.user_id
  WHERE tickets.created_at BETWEEN '2013-1-1' AND '2013-12-31'
  GROUP BY users.username
  ORDER BY total_money DESC
  LIMIT 3
;

-- 5. Count all flights to OR from the city of Smithshire that did not land in Delaware
SELECT
  destination_state.name,
  origin_city.name,
  destination_city.name
  FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states origin_state ON origin_state.id = origin.state_id
  JOIN states destination_state ON destination_state.id = destination.state_id
  JOIN cities origin_city ON origin_city.id = origin.city_id
  JOIN cities destination_city ON destination_city.id = destination.city_id
  WHERE destination_state.name != 'Delaware'
    AND (
      origin_city.name = 'Smithshire'
      OR destination_city.name = 'Smithshire'
    )
;

-- 6. Return the range of lengths of flights in the system(the maximum, and the minimum).
SELECT
  MIN(arrival_time - departure_time) AS min_flight_length,
  MAX(arrival_time - departure_time) AS max_flight_length
  FROM flights
;










