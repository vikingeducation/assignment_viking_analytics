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

User.find_by_sql("
SELECT u.first_name,u.last_name,SUM(f.price) AS Total from users u 
JOIN itineraries i ON i.user_id = u.id
JOIN tickets t ON t.itinerary_id = i.id
JOIN flights f ON f.id = t.flight_id
GROUP BY u.id
ORDER BY Total DESC
LIMIT 3
")


5.Count all flights to or from the city of Lake Vivienne that did not land in Florida

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

Return the range of lengths of flights in the system(the maximum, and the minimum).