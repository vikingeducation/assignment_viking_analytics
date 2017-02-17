1. Find the top 5 most expensive flights that end in California.

```
Flight.find_by_sql "SELECT * FROM flights JOIN airports ON airports.id = flights.destination_id JOIN states ON states.id = state_id WHERE states.name = 'California' ORDER BY price DESC LIMIT 5"
```

2. Find the shortest flight that username "ryann_anderson" took.

```
Ticket.find_by_sql "SELECT * FROM tickets JOIN itineraries ON tickets.itinerary_id = itineraries.id JOIN users ON users.id = user_id JOIN flights ON flight_id = flights.id WHERE username = 'abigail_wisoky' ORDER BY distance LIMIT 1"
```

3. Find the average flight distance for flights entering or leaving each city in Florida

```
Flight.find_by_sql "SELECT AVG(flights.distance) FROM flights JOIN airports a1 ON flights.origin_id = a1.id JOIN airports a2 ON a2.id = flights.destination_id JOIN states ON a2.state_id = states.id WHERE states.name = 'Florida'"
```

4. Find the 3 users who spent the most money on flights in 2013

```
Flight.find_by_sql "SELECT SUM(f13.price) AS amt, users.last_name, users.first_name  FROM (SELECT * FROM flights WHERE departure_time BETWEEN '2013-01-01' AND '2013-12-01') AS f13 JOIN tickets ON tickets.flight_id = f13.id JOIN itineraries ON itineraries.id = itinerary_id JOIN users ON users.id = itineraries.user_id GROUP BY last_name, first_name ORDER BY amt DESC LIMIT 3"
```

5. Count all flights to or from the city of Lake Vivienne that did not land in Florida

```
Airport.find_by_sql "SELECT *  FROM airports JOIN cities ON airports.city_id = cities.id JOIN flights f1 ON f1.origin_id = airports.id OR f1.destination_id = airports.id  WHERE name = 'Lake Vivienne' AND f1.destination_id != ("SELECT cities.id FROM airports JOIN cities ON cities.id = airports.city_id WHERE cities.name = 'Florida'" )
```

6. Return the range of lengths of flights in the system(the maximum, and the minimum).

```
Flight.find_by_sql "SELECT MAX(distance), MIN(distance) FROM flights"
```
