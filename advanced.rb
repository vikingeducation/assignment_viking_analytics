# Find the most popular travel destination for users who live in Kansas.
Flight.find_by_sql(
"SELECT airports.long_name,
       COUNT(flights.destination_id)
  FROM flights
  JOIN airports
    ON flights.destination_id = airports.id
  WHERE flights.id IN (
    SELECT tickets.flight_id
      FROM tickets
      JOIN itineraries
        ON tickets.itinerary_id = itineraries.id
      JOIN users
        ON itineraries.user_id = users.id
      JOIN states
        ON users.state_id = states.id
      WHERE states.name = 'Kansas'
  )
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1"
)

# How many flights have round trips possible? In other words, we want the
# count of all airports where there exists a flight FROM that airport and a
# later flight TO that airport.
Flight.find_by_sql(
"SELECT COUNT(*)
  FROM flights f1
  JOIN flights f2
    ON f1.origin_id = f2.destination_id
  WHERE f2.departure_time > f1.arrival_time"
)

# Find the cheapest flight that was taken by a user who only had one itinerary.
Flight.find_by_sql(
"SELECT * FROM flights
 WHERE id = (
   SELECT flights.id FROM itineraries
     JOIN tickets ON itineraries.id = tickets.itinerary_id
     JOIN flights ON flights.id = tickets.flight_id
     GROUP BY flights.id
     HAVING COUNT(itineraries.user_id) = 1
     ORDER BY flights.price
     LIMIT 1
 )"
)

# Find the average cost of a flight itinerary for users in each state in 2012.
Flight.find_by_sql(
"SELECT states.name AS state_name,
       AVG(price) AS avg_cost
  FROM flights
  JOIN airports
    ON flights.origin_id = airports.id
  JOIN states
    ON airports.state_id = states.id
  GROUP BY 1
  ORDER BY 1"
)

# Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights
# over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but
# do not take any flights over 400 miles in distance. Note: This can be ~50
# lines long but doesn't require any subqueries.
Flight.find_by_sql(
"SELECT flights.*
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
  WHERE
    # between May 6, 2013 and the next six weeks
    flights.departure_time BETWEEN timestamp '2013-05-06' AND
                                   timestamp '2013-05-06' + interval '42 days'
    # do not take any flights over 400 miles in distance
    AND flights.distance <= 400
    # that connect Oregon, Pennsylvania and Arkansas
    AND origin_state.name IN ('Oregon', 'Pennsylvania', 'Arkansas') OR
        destination_state.name IN ('Oregon', 'Pennsylvania', 'Arkansas')
  ORDER BY flights.price"
)
