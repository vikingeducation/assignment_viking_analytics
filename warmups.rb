# Get a list of all users in California
User.find_by_sql(
  "SELECT users.*
    FROM users
    JOIN states
      ON users.state_id = states.id
    WHERE states.name = 'California'"
)

# Get a list of all airports in Minnesota
Airport.find_by_sql(
"SELECT airports.*
  FROM airports
  JOIN states
    ON airports.state_id = states.id
  WHERE states.name = 'Minnesota'"
)

# Get a list of all payment methods used on itineraries by the user
# with email address "heidenreich_kara@kunde.net"
Itinerary.find_by_sql(
"SELECT itineraries.payment_method
  FROM itineraries
  JOIN users
    ON itineraries.user_id = users.id
  WHERE users.email = 'heidenreich_kara@kunde.net'")

# Get a list of prices of all flights whose origins are in Kochfurt
# Probably International Airport.
Flight.find_by_sql(
"SELECT flights.*
  FROM flights
  JOIN airports
    ON flights.origin_id = airports.id
  WHERE airports.long_name = 'Kochfurt Probably International Airport'")

# Find a list of all Airport names and codes which connect to the
# airport coded LYT.
Flight.find_by_sql(
"SELECT destinations.long_name, destinations.code
FROM flights
JOIN airports origins
 ON flights.origin_id = origins.id
JOIN airports destinations
 ON flights.destination_id = destinations.id
WHERE origins.code = 'LYT'")

# Get a list of all airports visited by user Dannie D'Amore after
# January 1, 2012.
# (Hint, see if you can get a list of all ticket IDs first).
# Note: Careful how you escape the quote in "D'Amore"...
# escaping in SQL is different from Ruby.
Flight.find_by_sql(
"SELECT airports.*
  FROM flights
  JOIN airports
    ON flights.origin_id = airports.id
  JOIN tickets
    ON flights.id = tickets.flight_id
  JOIN itineraries
    ON itineraries.id = tickets.itinerary_id
  JOIN users
    ON itineraries.user_id = users.id
  WHERE users.first_name = 'Dannie'
    AND users.last_name = 'D''Amore'
    AND flights.departure_time > timestamp '2012-01-01'")
