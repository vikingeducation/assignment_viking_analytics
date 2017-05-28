# assignmnent_viking_analytics

Chad Lucas

Queries 1: Warmups

1. SELECT * FROM users WHERE state_id = 3

2. SELECT * FROM airports WHERE state_id = 23

3. SELECT payment_method 
     FROM itineraries JOIN users
     ON itineraries.user_id = users.id 
   WHERE users.emai = ('kyler_hudson@maggiojacobs.info')

4.SELECT price FROM flights JOIN airports
ON flights.origin_id = airports.city_id WHERE airports.long_name LIKE ('Kuhicport%')

5. SELECT airports.long_name, airports.code FROM airports JOIN flights ON flights.destination_id = airports.city_id WHERE airports.code = ('YLT')

6. SELECT long_name FROM itineraries JOIN tickets
     ON tickets.itinerary_id = itineraries.id JOIN flights
     ON tickets.flight_id = flights.id JOIN users
     ON itineraries.user_id = users.id
   WHERE users.last_name LIKE ('%Wyman')
     AND flights.departure_time > '2012-01-01'


Queries 2: Adding in Aggregation

1. SELECT * FROM flights JOIN airports
     ON airports.id = destination_id JOIN states
     ON states.id = airports.state_id
   WHERE name = ('California')
     ORDER BY price ASC
     LIMIT 5

2.SELECT (MIN)distance FROM tickets JOIN itineraries
ON itineraries.id = tickets.itinerary_id JOIN flights
ON flights.id = tickets.flight_id JOIN users
ON users.id = itineraries.user_id
WHERE username = ('madisen')


3. SELECT (AVG)distance FROM flights 
     JOIN airports ON airports.id = origin_id
     JOIN states ON states.id = state_id
   WHERE name = 'Florida'

4. SELECT users.username, SUM(flights.price) AS total FROM flights
JOIN tickets ON tickets.flight_id = flights.id
JOIN itineraries ON itineraries.id = tickets.itinerary_id
JOIN users ON users.id = itineraries.user_id
GROUP BY users.username
ORDER BY total DESC
LIMIT 3


5. SELECT COUNT(origin_id), COUNT(destination_id)
     FROM flights
       JOIN airports ON airports.id = flights.origin_id
       JOIN cities ON city_id = cities.id
     WHERE destination.id NOT = 9

6. SELECT MIN(distance), MAX(distance) FROM     flights


Queries 3 :Advanced

1. SELECT cities.name FROM flights
    JOIN tickets ON tickets.flight_id = flights.id
    JOIN itineraries ON itineraries.id = tickets.itinerary_id
    JOIN users ON users.id = itineraries.user_id
    JOIN airports ON airports.id = flights.destination_id
    JOIN states ON airports.city_id
   WHERE states.name = 'Kansas'
   GROUP BY cities.name

 2.  SELECT COUNT(flights.id)
 		FROM flights

     WHERE flights.origin_id = flights.destination_id


 3. SELECT min(price), users.username 
     FROM flights JOIN tickets
       ON tickets.flight_id = flights.id
       JOIN itineraries
       ON itineraries.id = tickets.itinerary_id
      JOIN users ON users.id = itineraries.user_id
     WHERE flights.price
     HAVING COUNT(itineraries.id) = 1


4. SELECT AVG(price), states.name
    FROM flights
    ...
