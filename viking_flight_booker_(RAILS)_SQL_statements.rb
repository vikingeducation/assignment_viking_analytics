Viking Flight Booker (RAILS)
----------------------------
User.find_by_sql 

Queries 1: Warmups

1. User.find_by_sql "SELECT users.first_name, users.last_name, cities.name AS city FROM users JOIN states  ON states.id = users.state_id JOIN cities  ON cities.id = users.city_id WHERE states.name = 'CA'"

2. User.find_by_sql "SELECT airports.long_name AS airport_name, cities.name AS city, states.name AS state FROM airports JOIN cities ON cities.id = airports.city_id JOIN states ON states.id = airports.state_id WHERE states.name = 'Minnesota'"

3.  SELECT users.first_name, 
           users.last_name, 
           itineraries.payment_method
      FROM users
      JOIN itineraries
        ON users.id = itineraries.user_id
      WHERE users.email = 'heidenreich_kara@kunde.net'

    User.find_by_sql "SELECT users.first_name, users.last_name, users.email, itineraries.payment_method FROM users JOIN itineraries ON users.id = itineraries.user_id WHERE users.email = 'mcdermott.casper@feil.com' ORDER BY users.email"


4.  SELECT origin_airport.long_name, flights.price
    FROM flights
    JOIN airports origin_airport
      ON origin_airport.id = flights.origin_id
    WHERE origin_airport.long_name = 'Kochfurt Probably International Airport'

    User.find_by_sql "SELECT origin_airport.long_name, flights.price FROM flights JOIN airports origin_airport ON origin_airport.id = flights.origin_id WHERE origin_airport.long_name = 'East Ara Probably International Airport'"

5.  SELECT DISTINCT 
        destination_airport.long_name AS 'airport connecting to LYT',
        destination_airport.code 
      FROM flights
      JOIN airports origin_airport
        ON origin_airport.id = flights.origin_id
      JOIN airports destination_airport
        ON destination_airport.id = flights.destination_id
      WHERE origin_airport.code = 'LYT'
      ORDER BY destination_airport.long_name
        # strictly speaking not 100% accurate as this assunes 
        # there are always reciprocal flights between airports
        # which is alomost but not totally true

    User.find_by_sql ""



6.  SELECT DISTINCT airports.code, 
           airports.long_name, 
           cities.name, 
           states.name
      FROM users
      JOIN itineraries
        ON users.id = itineraries.user_id
      JOIN tickets
        ON itineraries.id = tickets.itinerary_id
      JOIN flights
        ON flights.id = itineraries.flight_id
      JOIN airports
        ON airports.id = flights.origin_id
        OR airports.id = flights.destination_id
      JOIN cities
        ON cities.id = airports.city_id
      JOIN states
        ON states.id = airports.state_id
      WHERE users.first_name = 'Dannie'
        AND users.last_name = 'D''Amore'
        AND flights.departure_time >= 2012 # the year portion




Queries 2: Aggregation

1.  SELECT origin_airport.code, 
      origin_airport.long_name, 
      destination_airport.code, 
      destination_airport.long_name, 
      flights.price
    FROM flights
    JOIN airports origin_airport
      ON origin_airport.id = flights.origin_id
    JOIN airports destination_airport
      ON destination_airport.id = flights.destination_id
    JOIN states destination_state
      ON states.id = destination_airport.state_id
    WHERE destination_state.name = 'California'
    ORDER BY flights.price DESC
    LIMIT 5

2.  SELECT users.first_name, 
           users.last_name,
           origin_airport.code, 
           origin_airport.long_name, 
           destination_airport.code, 
           destination_airport.long_name, 
           flights.distance
      FROM users
      JOIN itineraries
        ON users.id = itineraries.user_id
      JOIN tickets
        ON itineraries.id = tickets.itinerary_id
      JOIN flights
        ON flights.id = itineraries.flight_id
      JOIN airports origin_airport
        ON origin_airport.id = flights.origin_id
      JOIN airports destination_airport
        ON destination_airport.id = flights.destination_id
      WHERE users.user_name = 'ryann_anderson'
      ORDER BY flights.distance
      LIMIT 1

3. SELECT AVG(flights.distance) AS "average flight distance to/from cities in Florida"
    FROM flights
    JOIN airports
      ON airports.id = flights.origin_id
      OR airports.id = flights.destination_id
    JOIN states
      ON states.id = airports.state_id
    WHERE states.name = 'Florida'

4.  SELECT users.first_name
           users.last_name
           SUM(flights.price)
      FROM users
      JOIN itineraries
        ON users.id = itineraries.user_id
      JOIN tickets
        ON itineraries.id = tickets.itinerary_id
      JOIN flights
        ON flights.id = itineraries.flight_id
      WHERE itineraries.created_at = 2013 # year portion
      GROUP BY users.last_name, users.first_name
      ORDER BY users.last_name, users.first_name
      LIMIT 3

5.  SELECT COUNT(*)              # test with SELECT *
      FROM flights
      JOIN airports origin_airport
        ON origin_airport.id = flights.origin_id
      JOIN cities origin_city
        ON origin_city.id = origin_airport.city_id

      JOIN airports destination_airport
        ON destination_airport.id = flights.destination_id
      JOIN cities destination_city
        ON destination_city.id = destination_airport.city_id

      JOIN states destination_state
        ON destination_state.id = destination_airport.state_id

      HAVING (origin_city.name = 'Lake Vivienne'
          OR  destination_city.name = 'Lake Vivienne')
         AND destination_state.name != 'Florida'                                  
6.  SELECT MAX(distance) AS max_flight_length, 
           MIN(distance) AS min_flight_length
      FROM flights

Queries 3: Advanced
-------------------

1. SELECT DISTINCT users_home_state.name, 
          COUNT(destination_city.name)
      FROM users
      JOIN itineraries
        ON users.id = itineraries.user_id
      JOIN tickets
        ON itineraries.id = tickets.itinerary_id
      JOIN flights
        ON flights.id = itineraries.flight_id
      JOIN airports destination_airport
        ON destination_airport.id = flights.destination_id
      JOIN cities destination_city
        ON destination_city.id = destination_airport.city_id
      JOIN states users_home_state
        ON users_home_state.id = users.state_id
      GROUP BY users_home_state.name, 
               destination_city.name
      HAVING users_home_state.name = 'Kansas'
      ORDER BY COUNT(destination_city.name) DESC
      LIMIT 10

# Notes. Test from small to larger instructions. First see if Kansas 
#   is a state

2.  SELECT COUNT(flights_from_origin.origin_id)
      FROM flights flights_from_origin
      JOIN flights flights_from_destination
        ON flights_from_origin.destination_id = flights_from_destination.origin_id
        AND flights_from_origin.arrival_time + 3600 < flights_from_destination.departure_time 
          # 3600 seconds (60 mins) for transfer
          # assumption: return flight required on same day as departure

          # test with listing of:
           # origin_id
           # destination_id
           # flights_from_origin.arrival_time, 
           # flights_from_destination.departure_time

3.  SELECT users.first_name,
           users.last_name,
           MIN(flights.price)
      FROM users
      JOIN itineraries
        ON users.id = itineraries.user_id
      JOIN tickets
        ON itineraries.id = tickets.itinerary_id
      JOIN flights
        ON flights.id = itineraries.flight_id
      GROUP BY users.last_name, users.first_name, itineraries.id 
      HAVING COUNT(itineraries.id) = 1

      # test by printing users' names + itin's.id + tickets.id + flights.prices
      #      ORDER BY users.last_name, users.first_name, 
      #      itineraries.id, tickets.id, flights.price
      # LIMIT 25

4.    SELECT states.name, AVG(flights.price)
        FROM users
        JOIN itineraries
          ON users.id = itineraries.user_id
        JOIN tickets
          ON itineraries.id = tickets.itinerary_id
        JOIN flights
          ON flights.id = itineraries.flight_id
        JOIN states
          ON states.id = users.state_id
        GROUP BY states.name,
                 flights.price
        HAVING itineraries.created_at = 2012 # extract year

      # test by printing states.name, flight prices
      # LIMIT 20









