1. Find the most popular travel destination for users who live in Kansas.

```
User.find_by_sql "SELECT cities.name FROM users JOIN states ON states.id = users.state_id JOIN itineraries ON itineraries.user_id = users.id JOIN tickets ON tickets.itinerary_id = itineraries.id JOIN flights ON flight_id = flights.id JOIN airports ON airports.id = destination_id JOIN cities ON airports.city_id = cities.id WHERE states.name = 'Kansas'"
```

2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.

```
  Flight.find_by_sql "SELECT f1.*, f2.origin_id as f2_origin, f2.destination_id as f2_destination, f2.departure_time AS f2_departure FROM flights f1 JOIN flights f2 ON f1.origin_id = f2.destination_id WHERE f1.destination_id = f2.origin_id AND DATE_PART('day',  f2.departure_time- f1.departure_time) * 24 + DATE_PART('hour', f2.departure_time- f1.departure_time) BETWEEN 0 AND 24"
  ```

3. Find the cheapest flight that was taken by a user who only had one itinerary.

```
Itinerary.find_by_sql "SELECT * FROM itineraries JOIN (SELECT COUNT(user_id), user_id FROM itineraries GROUP BY user_id HAVING COUNT(user_id) = 1) AS u ON u.user_id = itineraries.user_id JOIN tickets ON tickets.itinerary_id = itineraries.id JOIN flights ON flights.id = tickets.flight_id ORDER BY price LIMIT 1"
```

4. Find the average cost of a flight itinerary for users in each state in 2012.

```
Itinerary.find_by_sql "SELECT AVG(price), states.name FROM itineraries JOIN tickets ON tickets.itinerary_id = itineraries.id JOIN (SELECT * FROM flights WHERE departure_time BETWEEN '2012-01-01' AND '2012-12-31') AS f ON f.id = tickets.flight_id JOIN users ON user_id = users.id JOIN states ON states.id = state_id GROUP BY states.name"
```

5. Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.


