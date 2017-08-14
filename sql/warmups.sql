-- 1. Get a list of all users in California
SELECT users.username AS username, states.name AS state_name FROM users
  JOIN states ON states.id = users.state_id
  WHERE states.name = 'California'
;

-- 2. Get a list of all airports in Kadeton
SELECT airports.long_name AS airport, cities.name AS city FROM airports
  JOIN cities ON cities.id = airports.city_id
  WHERE cities.name = 'Kadeton'
;

-- 3. Get a list of all payment methods used on itineraries by the user with email address 'senger.krystel@marvin.io'
SELECT users.email AS user_email, itineraries.payment_method AS payment_method FROM itineraries
  JOIN users ON users.id = itineraries.user_id
  WHERE users.email = 'senger.krystel@marvin.io'
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

-- 6. Get a list of all airports visited by user Krystel Senger after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first).
SELECT airports.long_name AS airport, CONCAT(users.first_name, ' ', users.last_name) AS user FROM airports
  JOIN flights origin ON airports.id = origin.origin_id
  JOIN flights destination ON airports.id = destination.destination_id
  JOIN tickets ON origin.id = tickets.flight_id
  JOIN itineraries ON itineraries.id = tickets.itinerary_id
  JOIN users ON users.id = itineraries.user_id
  WHERE users.first_name = 'Krystel'
    AND users.last_name = 'Senger'
    AND origin.departure_time > '2012-1-1'
;
