# assignmnent_viking_analytics

### Sean Luckett

## Queries 2: Adding in Aggregation
1. Find the top 5 most expensive flights that end in California.
```ruby
Flight.find_by_sql "
    SELECT f.origin_id, f.destination_id, f.price
    FROM flights f
    JOIN states ON f.destination_id=states.id
    WHERE f.destination_id = (SELECT id FROM states WHERE name='California')
    ORDER BY f.price DESC
"
```

2. Find the shortest flight that username "ryann_anderson" took. *N/A -- no ryann_anderson in auto-generated data*

3. Find the average flight distance for flights entering or leaving each city in Florida. *N/A -- no airports in FL*
```ruby
Flight.find_by_sql "SELECT
  airports.long_name,
  AVG(flights.distance)
FROM flights
JOIN airports
  ON flights.origin_id = airports.id
    OR flights.destination_id = airports.id
WHERE airports.state_id = (
  SELECT id
  FROM states
  WHERE name='Florida'
)
GROUP BY airports.long_name"
```
4. Find the 3 users who spent the most money on flights in 2013
```ruby
User.find_by_sql '
SELECT users.first_name, users.last_name, SUM(flights.price)
FROM users
JOIN itineraries
  ON users.id = itineraries.user_id
JOIN tickets
  ON tickets.itinerary_id = itineraries.id
JOIN flights
  ON flights.id = tickets.flight_id
GROUP BY users.first_name, users.last_name
ORDER BY SUM(flights.price) DESC
LIMIT 3;
'
```
5. Count all flights to or from the city of Lake Vivienne that did not land in Florida *N/A no data*
6. Return the range of lengths of flights in the system(the maximum, and the minimum)
```ruby
Flight.find_by_sql '
SELECT MIN(distance) as min_distance,
  MAX(distance) as max_distance
FROM flights
'
```
## Queries 3: Advanced
1. Find the most popular travel destination for users who live in Kansas *N/A no flights from Kansas*
```ruby
Airport.find_by_sql "
SELECT airports.long_name, cities.name, COUNT(flights.destination_id)
FROM airports
  JOIN cities
  ON cities.id = airports.city_id
  JOIN flights
  ON airports.id = flights.origin_id
WHERE airports.state_id = (
  SELECT id
  FROM states
  WHERE name = 'Kansas'
)
GROUP BY airports.long_name, cities.name
ORDER BY COUNT(flights.destination_id) DESC
LIMIT 1
"
```
2. How many flights have round trips possible?
```ruby

```