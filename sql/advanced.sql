-- 1. Find the most popular travel destination for users who live in California.
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
  WHERE user_state.name = 'California'
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
