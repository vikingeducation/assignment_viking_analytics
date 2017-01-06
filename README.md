# assignmnent_viking_analytics

Tingting

# Queries 1: Warmups

Get a list of all users in California

  User.find_by_sql("
  SELECT users.username
    FROM users JOIN states ON users.state_id = states.id
    WHERE states.name = 'California'
  ")

Get a list of all airports in Minnesota

  Airport.find_by_sql("
  SELECT airports.long_name
    FROM airports JOIN states ON airports.state_id = states.id
    WHERE states.name = 'Minnesota'
  ")

Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"

  Itinerary.find_by_sql("
  SELECT itineraries.payment_method
    FROM itineraries JOIN users ON itineraries.user_id = users.id
    WHERE users.email = 'heidenreich_kara@kunde.net'
  ")

Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
  
    Flight.find_by_sql("
    SELECT flights.price
      FROM flights JOIN airports ON flights.origin_id = airports.id
      WHERE airports.long_name = 'Kochfurt Probably International Airport'
    ")

Find a list of all Airport names and codes which connect to the airport coded LYT.

  Airport.find_by_sql("
  SELECT airports.long_name, code
    FROM airports JOIN flights ON airports.id = flights.destination_id
    WHERE airports.code = 'LYT'
  ")

Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.

  Airport.find_by_sql("
  SELECT airports.long_name
    FROM users 
    JOIN itineraries ON users.id = itineraries.user_id
    JOIN tickets ON itineraries.id = tickets.itinerary_id
    JOIN flights ON tickets.flight_id = flights.id
    JOIN airports ON flights.destination_id = airports.id
    WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore' AND flights.arrival_time > '2012-01-01'
  ")

# Queries 2: Adding in Aggregation

Find the top 5 most expensive flights that end in California.

  Flight.find_by_sql("
  SELECT flights.id, flights.price, flights.destination_id, airports.state_id, airports.code, states.name
    FROM flights
    JOIN airports ON flights.destination_id = airports.id
    JOIN states ON airports.state_id = states.id
    WHERE states.name = 'California'
    ORDER BY flights.price DESC
    LIMIT 5
  ")

Find the shortest flight that username "ryann_anderson" took.

  Flight.find_by_sql("
  SELECT MIN(flights.distance)
    FROM flights
    JOIN tickets ON flights.id = tickets.flight_id
    JOIN itineraries ON tickets.itinerary_id = itineraries.id
    JOIN users ON itineraries.user_id = users.id
    WHERE users.username = 'ryann_anderson'
  ")

Find the average flight distance for flights entering or leaving 
each city in Florida

  Flight.find_by_sql("
  SELECT AVG(distance)
    FROM (
    SELECT distance 
      FROM flights
      JOIN airports ON flights.origin_id = airports.id 
      JOIN states on airports.state_id = states.id
      WHERE states.name = 'Florida'
    UNION
    SELECT distance
      FROM flights 
      JOIN airports ON flights.destination_id = airports.id 
      JOIN states on airports.state_id = states.id
      WHERE states.name = 'Florida') 
        AS florida_flights
  ")

Find the 3 users who spent the most money on flights in 2013

  User.find_by_sql("
  SELECT users.*, SUM(flights.price)
    FROM flights 
    JOIN tickets ON flights.id = tickets.flight_id
    JOIN itineraries ON tickets.itinerary_id = itineraries.id
    JOIN users ON itineraries.user_id = users.id
    WHERE flights.departure_time BETWEEN '2013-01-01' AND '2012-12-31'
    GROUP BY users.id
    ORDER BY SUM(flights.price) DESC
    LIMIT 3
  ")

Count all flights to or from the city of Lake Vivienne that did not land in Florida

Flight.find_by_sql("
SELECT SUM(count)
  FROM (
    SELECT COUNT(flights.id)  
      FROM flights 
      JOIN airports ON flights.origin_id = airports.id
      JOIN cities ON airports.city_id = cities.id
      JOIN states ON airports.state_id = states.id
      WHERE cities.name = 'Lake Vivienne' AND flights.destination_id NOT IN 
        (SELECT airports.id
          FROM airports JOIN states on airports.state_id = states.id
          WHERE states.name = 'Florida')
    UNION 
    SELECT COUNT(flights.id)  
      FROM flights 
      JOIN airports ON flights.destination_id = airports.id
      JOIN cities ON airports.city_id = cities.id
      JOIN states ON airports.state_id = states.id
      WHERE cities.name = 'Lake Vivienne' AND flights.destination_id NOT IN 
        (SELECT airports.id
          FROM airports JOIN states on airports.state_id = states.id
          WHERE states.name = 'Florida')) AS relevant_flights 
")

Return the range of lengths of flights in the system(the maximum, and the minimum).

Flight.find_by_sql("
SELECT MIN(distance), MAX(distance)
  FROM flights
")

# Queries 3: Advanced

Find the most popular travel destination for users who live in Kansas.

Flight.find_by_sql("
SELECT flights.destination_id AS dest_id, COUNT(flights.destination_id) as frequency
  FROM users
  JOIN itineraries ON users.id = itineraries.user_id
  JOIN tickets ON itineraries.id = tickets.itinerary_id
  JOIN flights ON tickets.flight_id = flights.id
  WHERE users.state_id IN 
    (SELECT states.id
      FROM states
      WHERE states.name = 'Kansas')
  GROUP BY dest_id
  ORDER BY frequency DESC
  LIMIT 1
  ")

How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.

Airport.find_by_sql("
SELECT COUNT(*)
  FROM (
    SELECT leave.id leave_id, leave.origin_id leave_origin, return.destination_id return_dest, return.id return_id, leave.destination_id leave_dest, return.origin_id return_origin
    FROM flights AS leave 
    JOIN flights AS return 
    ON leave.destination_id = return.origin_id
    AND leave.origin_id = return.destination_id
  ) AS relevant_flights
")

Find the cheapest flight that was taken by a user who only had one itinerary.

Flight.find_by_sql("
SELECT MIN(price)
  FROM users
  JOIN itineraries ON users.id = itineraries.user_id
  JOIN tickets ON itineraries.id = tickets.itinerary_id
  JOIN flights ON flights.id = tickets.flight_id
  WHERE users.id IN
  /* users with 1 itinerary */
  (SELECT users.id
      FROM users
      JOIN itineraries ON users.id = itineraries.user_id
      JOIN tickets ON itineraries.id = tickets.itinerary_id
      GROUP BY users.id
      HAVING COUNT(users.id) = 1)
")

Find the average cost of a flight itinerary for users in each state in 2012.

Flight.find_by_sql("
SELECT states.id, AVG(flights.price)
  FROM users 
  JOIN itineraries ON users.id = itineraries.user_id
  JOIN tickets ON itineraries.id = tickets.itinerary_id
  JOIN flights ON flights.id = tickets.flight_id 
  JOIN airports ON flights.origin_id = airports.id
  JOIN states ON airports.state_id = states.id
  WHERE flights.arrival_time BETWEEN '2012-01-01' AND '2012-12-31'
  AND flights.departure_time BETWEEN '2012-01-01' AND '2012-12-31'
  GROUP BY states.id
  ORDER BY states.id
")

Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.
