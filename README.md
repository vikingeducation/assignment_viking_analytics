# assignmnent_viking_analytics


Deepa + Julia

Get a list of all users in California
```
User.find_by_sql("
SELECT u.* from users u 
JOIN states s ON u.state_id = s.id 
WHERE s.name = 'California'
")
```
Get a list of all airports in Minnesota
```
Airport.find_by_sql("
SELECT a.* from airports a 
JOIN states s ON a.state_id = s.id 
WHERE s.name = 'Minnesota'
")
```
Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net" (with multiplier = 5, that user doesn't exist, so we used another one)
```
Itinerary.find_by_sql("
SELECT i.payment_method FROM itineraries i
JOIN users u on u.id = i.user_id
WHERE u.email = 'heathcote.davin@rutherfordcummerata.info'
")
```
User.find_by_sql("SELECT * from users where email like 'heidenreich%'")

Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
Flight.find_by_sql("
SELECT f.price FROM flights f 
JOIN airports a ON a.id = f.origin_id
WHERE a.long_name = 'Edisonmouth Probably International Airport'
")
```
Find a list of all Airport names and codes which connect to the airport coded LYT.

-- airport -- flight -- airport
```
Airport.find_by_sql("
SELECT astart.long_name, astart.code FROM airports astart
JOIN flights f on f.origin_id = astart.id
JOIN airports aconnect ON aconnect.id = f.destination_id
WHERE aconnect.code = 'SQU'
")
```

Airport.find_by_sql("
SELECT a.long_name, a.code FROM airports a
WHERE a.code = 'SQU'
")


Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby. (can't find special character, but it would be 'D\'\Amore' or 'D'''Amore')

```
Airport.find_by_sql(
"SELECT a.long_name from users u
 JOIN itineraries i ON u.id = i.user_id
 JOIN tickets t ON t.itinerary_id = i.id
 JOIN flights f ON f.id = t.flight_id
 JOIN airports a ON a.id = f.origin_id OR a.id = f.destination_id
 WHERE u.first_name ='Ilene'")
```

Queries 2: Adding in Aggregation

1. Find the top 5 most expensive flights that end in California.
```
Flight.find_by_sql("
SELECT f.id,f.price FROM flights f
JOIN airports a ON f.destination_id = a.id
JOIN states s ON s.id = a.state_id 
WHERE s.name ilike 'california'
ORDER BY f.price DESC
LIMIT 5
")

```
2. Find the shortest flight that username "ryann_anderson" took.

```
User.find_by_sql("
SELECT u.username, f.id, (f.arrival_time - f.departure_time ) AS flight_time FROM users u
JOIN itineraries i ON u.id = i.user_id
JOIN tickets t ON t.itinerary_id = i.id
JOIN flights f ON t.flight_id = f.id 
WHERE u.username ilike 'rashad'
ORDER BY flight_time 
LIMIT 5
")
```

3. Find the average flight distance for every city in Florida

```
User.find_by_sql("
SELECT a.city_id,AVG(f.distance) AS Average_Distance FROM flights f
JOIN airports a ON a.id = f.origin_id OR a.id = f.destination_id
JOIN states s ON s.id = a.state_id
WHERE s.name = 'Florida'
GROUP BY a.city_id
")
```


4. Find the 3 users who spent the most money on flights in 2013
```
User.find_by_sql("
SELECT u.first_name,u.last_name,SUM(f.price) AS Total
FROM users u 
JOIN itineraries i ON i.user_id = u.id
JOIN tickets t ON t.itinerary_id = i.id
JOIN flights f ON f.id = t.flight_id
WHERE f.departure_time BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY u.id
ORDER BY Total DESC
LIMIT 3
")
```

5.Count all flights to or from the city of Lake Vivienne that did not land in Florida
```
Flight.find_by_sql("
SELECT COUNT(*) AS Flights_NOT_IN_FLORIDA from flights f
JOIN airports a ON f.origin_id = a.id
JOIN cities c ON c.id = a.city_id
WHERE c.name = 'Lake Eino' and f.destination_id IN (
  SELECT f.id from flights f
  JOIN airports a ON f.destination_id = a.id 
  JOIN states s ON s.id = a.state_id
  WHERE s.name != 'Florida')
")
```

6. Return the range of lengths of flights in the system(the maximum, and the minimum).
```
Flight.find_by_sql("
SELECT min(f.distance), max(f.distance) 
FROM flights f")
```


1. Find the most popular travel destination for users who live in Kansas.
```
City.find_by_sql("
SELECT c2.name, count(flight_id) FROM cities c
  JOIN airports a ON a.city_id = c.id
  JOIN flights f on f.destination_id = a.id
  JOIN cities c2 ON c.id = a.city_id
  JOIN tickets t on t.flight_id = f.id
  JOIN itineraries i on i.id = t.itinerary_id
  JOIN users u on u.id = i.user_id
  JOIN states s on s.id = a.state_id
  WHERE s.name = 'Kansas'
  GROUP BY c2.name
  ORDER BY count DESC
  LIMIT 1
")
```

2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
```
Flight.find_by_sql("
SELECT COUNT(*) FROM flights f2
WHERE f2.destination_id IN(
  SELECT f.origin_id FROM flights f
  GROUP BY f.origin_id
  )
")
```
```
Flight.find_by_sql("
SELECT COUNT(DISTINCT(f.id)) FROM flights f
JOIN flights f2 ON f2.origin_id = f.destination_id
LIMIT 50
")
```
3. Find the cheapest flight that was taken by a user who only had one itinerary.
```
Flight.find_by_sql("
SELECT min(f.price) FROM flights f
JOIN tickets t ON t.flight_id = f.id
JOIN itineraries i ON t.itinerary_id = i.id
JOIN users u ON i.user_id = u.id
WHERE u.id IN (
    -- users with only one flight
    SELECT u.id FROM users u
    JOIN itineraries i on i.user_id = u.id
    GROUP BY u.id
    HAVING count(i.id) = 1
    )
")
```
4. Find the average cost of a flight itinerary for users in each state in 2012.
```
Flight.find_by_sql("
SELECT s.name, avg(f.price) FROM flights f
JOIN tickets t ON t.flight_id = f.id
JOIN itineraries i ON t.itinerary_id = i.id
JOIN users u ON i.user_id = u.id
JOIN states s ON u.state_id = s.id
WHERE departure_time BETWEEN '2012-01-01 00:00:00' AND '2012-12-31 23:59:29'
GROUP BY s.id
ORDER BY s.name
")
```
5. Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.

pseudocode:
- May 6, 2013 + 6 weeks = June 10, 2013 (2013-06-10)
- destinations must include Oregon, Pennsylvania, and Arkansas
- will return 1 row for each flight we take
- flight.distance <= 400
- assumption: only direct flights
```

Flight.find_by_sql("
SELECT s.name AS orig, s2.name as dest, f.price, 
       f.distance, f.departure_time
    FROM flights f
    -- flights must be FROM one of the states
    JOIN airports a ON f.origin_id = a.id
    JOIN states s ON a.state_id = s.id
    -- flights must be TO one of the states
    JOIN flights f2 on f2.id = f.id
    JOIN airports a2 ON f2.destination_id = a2.id
    JOIN states s2 ON a2.state_id = s2.id
WHERE s.name IN ('Pennsylvania', 'Arkansas', 'Oregon') -- origin
AND s2.name IN ('Pennsylvania', 'Arkansas', 'Oregon') -- destination
AND f.distance <= 400
AND s.name != s2.name -- going to the same state doesn't help us


-- missing some direct flights during my timeframe, so I opened it up
-- AND f.departure_time BETWEEN '2013-05-06' AND '2013-06-10'
GROUP BY s.name, s2.name, f.price, f.distance, f.departure_time
")

```
Query to see all flights between the 3 states with no time or distance limits:
```
Flight.find_by_sql("
SELECT s.name AS orig, s2.name as dest, f.price, f.distance, f.departure_time
    FROM flights f
    -- flights must be FROM one of the states
    JOIN airports a ON f.origin_id = a.id
    JOIN states s ON a.state_id = s.id
    -- flights must be TO one of the states
    JOIN flights f2 on f2.id = f.id
    JOIN airports a2 ON f2.destination_id = a2.id
    JOIN states s2 ON a2.state_id = s2.id
WHERE s.name IN ('Pennsylvania', 'Arkansas', 'Oregon') -- origin
AND s2.name IN ('Pennsylvania', 'Arkansas', 'Oregon') -- destination
GROUP BY s.name, s2.name, f.price, f.distance, f.departure_time
")
```
Note: how to get dynamic dates
```
Flight.find_by_sql("
SELECT * from flights 
WHERE departure_time BETWEEN NOW() AND (NOW() + '6 weeks')
")
```

expecting?
only one flight to arkanas:
630.15 | 342      | Pennsylvania | Arkansas 

cheapest flight from arkansas to oregon:
778.23 | 244      | Arkansas     | Oregon 

