# Find the top 5 most expensive flights that end in California.
Flight.find_by_sql(
"SELECT flights.*
  FROM flights
  JOIN airports
    ON flights.origin_id = airports.id
  JOIN states
    ON airports.state_id = states.id
  WHERE states.name = 'California'
  ORDER BY flights.price DESC
  LIMIT 5"
)

# Find the shortest flight that username "ryann_anderson" took.
Flight.find_by_sql(
"SELECT flights.*
  FROM flights
  JOIN tickets
    ON flights.id = tickets.flight_id
  JOIN itineraries
    ON tickets.itinerary_id = itineraries.id
  WHERE itineraries.user_id = (SELECT id FROM users WHERE username = 'ryann_anderson')
  ORDER BY flights.distance ASC
  LIMIT 1"
)

# Find the average flight distance for flights entering or leaving each city in Florida
Flight.find_by_sql(
"SELECT AVG(flights.distance)
  FROM flights
  JOIN airports origin
    ON flights.origin_id = origin.id
  JOIN airports destination
    ON flights.destination_id = destination.id
  JOIN states origin_state
    ON origin.state_id = origin_state.id
  JOIN states destination_state
    ON destination.state_id = destination_state.id
  WHERE 'Florida' IN (origin_state.name, destination_state.name)"
)

# Find the 3 users who spent the most money on flights in 2013
Flight.find_by_sql(
"SELECT users.first_name, users.last_name,
       SUM(flights.price) AS total_money_spent
  FROM flights
  JOIN tickets
    ON flights.id = tickets.flight_id
  JOIN itineraries
    ON itineraries.id = tickets.itinerary_id
  JOIN users
    ON users.id = itineraries.user_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 3"
)

# Count all flights to or from the city of Lake Vivienne that did not land in Florida
Flight.find_by_sql(
"SELECT flights.id,
       COUNT(*) AS vivienne_not_florida
  FROM flights
  # airports
  JOIN airports origin
    ON flights.origin_id = origin.id
  JOIN airports destination
    ON flights.destination_id = destination.id
  # states
  JOIN states origin_state
    ON origin.state_id = origin_state.id
  JOIN states destination_state
    ON destination.state_id = destination_state.id
  # cities
  JOIN cities origin_city
    ON origin.city_id = origin_city.id
  JOIN cities destination_city
    ON destination.city_id = destination_city.id
  # filter
  WHERE 'Lake Vivienne' IN (origin_city.name, destination_city.name)
    AND destination_state.name != 'Florida'
  GROUP BY flights.id"
)

# Return the range of lengths of flights in the system(the maximum, and the minimum).
Flight.find_by_sql(
"SELECT MAX(flights.distance), MIN(flights.distance)
  FROM flights"
)
