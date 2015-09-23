# assignmnent_viking_analytics

## Bideo Wego

The answers to the assignment are shown below and available as SQL files in `/sql`.

# Warmups

```sql
-- 1. Get a list of all users in California
SELECT users.username AS username, states.name AS state_name FROM users
  JOIN states ON states.id = users.state_id
  WHERE states.name = 'California'
;

-- 2. Get a list of all airports in Minnesota
SELECT airports.long_name AS airport, cities.name AS city FROM airports
  JOIN cities ON cities.id = airports.city_id
  WHERE cities.name = 'Minnesota'
;

-- 3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
SELECT users.email AS user_email, itineraries.payment_method AS payment_method FROM itineraries
  JOIN users ON users.id = itineraries.user_id
  WHERE users.email = 'heidenreich_kara@kunde.net'
;

-- 4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
SELECT airports.long_name AS origin, flights.price AS flight_price FROM flights
  JOIN airports ON airports.id = flights.origin_id
  WHERE airports.long_name = 'Kochfurt Probably International Airport'
;

-- 5. Find a list of all Airport names and codes which connect to the airport coded LYT.
SELECT origin.long_name AS origin, origin.code AS origin_code, destination.code AS destination_code FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  WHERE destination.code = 'LYT'
;

-- 6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first).
SELECT airports.long_name AS airport, CONCAT(users.first_name, ' ', users.last_name) AS user FROM airports
  JOIN flights origin ON airports.id = origin.origin_id
  JOIN flights destination ON airports.id = destination.destination_id
  JOIN tickets ON origin.id = tickets.flight_id
  JOIN itineraries ON itineraries.id = tickets.itinerary_id
  JOIN users ON users.id = itineraries.user_id
  WHERE users.first_name = 'Dannie'
    AND users.last_name = 'D''Amore'
    AND origin.departure_time > '2012-1-1'
;

```

# Aggregation

```sql
-- 1. Find the top 5 most expensive flights that end in California.
SELECT CONCAT(origin.long_name, ' -> ', destination.long_name) AS flight, flights.price, states.name AS state  FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states ON states.id = destination.state_id
  WHERE states.name = 'California'
  ORDER BY price DESC
;

-- 2. Find the shortest flight that username "ryann_anderson" took.
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
  WHERE username = 'ryann_anderson'
  GROUP BY username, flight
;

-- 3. Find the average flight distance for every city in Florida
SELECT destination_state.name AS state, cities.name AS city, AVG(flights.distance) AS average_distance FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states origin_state ON origin_state.id = origin.state_id
  JOIN states destination_state ON destination_state.id = destination.state_id
  JOIN cities ON cities.id = destination.city_id
  WHERE destination_state.name = 'Florida'
  GROUP BY state, city
;

-- 4. Find the 3 users who spent the most money on flights in 2013
SELECT users.username, SUM(flights.price) AS total_money FROM flights
  JOIN tickets ON flights.id = tickets.flight_id
  JOIN itineraries ON itineraries.id = tickets.itinerary_id
  JOIN users ON users.id = itineraries.user_id
  WHERE tickets.created_at BETWEEN '2015-1-1' AND '2015-12-31'
  GROUP BY users.username
  ORDER BY total_money DESC
  LIMIT 3
;

-- 5. Count all flights to OR from the city of Lake Vivienne that did not land in Florida
SELECT
  COUNT(*)
  FROM flights
  JOIN airports origin ON origin.id = flights.origin_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states origin_state ON origin_state.id = origin.state_id
  JOIN states destination_state ON destination_state.id = destination.state_id
  JOIN cities origin_city ON origin_city.id = destination.city_id
  JOIN cities destination_city ON destination_city.id = destination.city_id
  WHERE destination_state.name != 'Florida'
    AND (
      origin_city.name = 'Lake Vivienne'
      OR destination_city.name = 'Lake Vivienne'
    )
;

-- 6. Return the range of lengths of flights in the system(the maximum, and the minimum).
SELECT
  MIN(arrival_time - departure_time) AS min_flight_length,
  MAX(arrival_time - departure_time) AS max_flight_length
  FROM flights
;

```

# Advanced

```sql
-- 1. Find the most popular travel destination for users who live in Kansas.
SELECT
  destination_city.name AS city,
  COUNT(destination_city) AS count
  FROM users
  JOIN states user_state ON user_state.id = users.state_id
  JOIN itineraries ON users.id = itineraries.user_id
  JOIN tickets ON itineraries.id = tickets.itinerary_id
  JOIN flights ON flights.id = tickets.flight_id
  JOIN airports destination ON destination.id = flights.destination_id
  JOIN states destination_state ON destination_state.id = destination.state_id
  JOIN cities destination_city ON destination_city.id = destination.city_id
  WHERE user_state.name = 'New Hampshire'
  GROUP BY city
  ORDER BY count
  LIMIT 1
;

-- 2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
SELECT
  COUNT(*) AS num_round_trip_flights
  FROM flights one
  JOIN flights two ON one.origin_id = two.destination_id
  WHERE one.arrival_time < two.departure_time
;

-- 3. Find the cheapest flight that was taken by a user who only had one itinerary.
SELECT * FROM flights
  WHERE id = (
    SELECT flights.id FROM itineraries
      JOIN tickets ON itineraries.id = tickets.itinerary_id
      JOIN flights ON flights.id = tickets.flight_id
      GROUP BY flights.id
      HAVING COUNT(itineraries.user_id) = 1
      ORDER BY flights.price
      LIMIT 1
  )
;

-- 4. Find the average cost of a flight itinerary for users in each state in 2012.
SELECT user_state.name, AVG(flights.price) FROM flights
  JOIN tickets ON flights.id = tickets.flight_id
  JOIN itineraries ON itineraries.id = tickets.itinerary_id
  JOIN users ON users.id = itineraries.user_id
  JOIN states user_state ON user_state.id = users.state_id
  WHERE flights.arrival_time BETWEEN '2012-1-1' AND '2012-12-31'
  GROUP BY user_state.name
  ORDER BY user_state.name
;


-- 5. Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance.
SELECT
  one.id AS one_id,
  one.price AS one_price,
  one_state_origin.name AS one_origin,
  one_state_destination.name one_destination,

  two.id AS two_id,
  two.price AS two_price,
  two_state_origin.name AS two_origin,
  two_state_destination.name AS two_destination,

  three.id AS three_id,
  three.price AS three_price,
  three_state_origin.name AS three_origin,
  three_state_destination.name three_destination,

  four.id AS four_id,
  four.price AS four_price,
  four_state_origin.name AS four_origin,
  four_state_destination.name AS four_destination

  FROM flights one

  JOIN flights two ON one.destination_id = two.origin_id
  JOIN flights three ON two.destination_id = three.origin_id
  JOIN flights four ON three.destination_id = four.origin_id
  
  JOIN airports one_airport_origin ON one_airport_origin.id = one.origin_id
  JOIN states one_state_origin ON one_state_origin.id = one_airport_origin.state_id
  JOIN airports one_airport_destination ON one_airport_destination.id = one.destination_id
  JOIN states one_state_destination ON one_state_destination.id = one_airport_destination.state_id

  JOIN airports two_airport_origin ON two_airport_origin.id = two.origin_id
  JOIN states two_state_origin ON two_state_origin.id = two_airport_origin.state_id
  JOIN airports two_airport_destination ON two_airport_destination.id = two.destination_id
  JOIN states two_state_destination ON two_state_destination.id = two_airport_destination.state_id

  JOIN airports three_airport_origin ON three_airport_origin.id = three.origin_id
  JOIN states three_state_origin ON three_state_origin.id = three_airport_origin.state_id
  JOIN airports three_airport_destination ON three_airport_destination.id = three.destination_id
  JOIN states three_state_destination ON three_state_destination.id = three_airport_destination.state_id

  JOIN airports four_airport_origin ON four_airport_origin.id = four.origin_id
  JOIN states four_state_origin ON four_state_origin.id = four_airport_origin.state_id
  JOIN airports four_airport_destination ON four_airport_destination.id = four.destination_id
  JOIN states four_state_destination ON four_state_destination.id = four_airport_destination.state_id

  WHERE one_state_origin.name = 'Oregon'
    AND two_state_destination.name = 'Pennsylvania'
    AND three_state_origin.name = 'Pennsylvania'
    AND four_state_destination.name = 'Arkansas'
    AND one.distance < 400
    AND two.distance < 400
    AND three.distance < 400
    AND four.distance < 400
    AND one.departure_time > '2013-5-6'
    AND two.departure_time > one.arrival_time
    AND three.departure_time > two.arrival_time
    AND four.departure_time > three.arrival_time
    AND four.arrival_time <= '2013-6-20'
  ORDER BY one.price, two.price
;

```