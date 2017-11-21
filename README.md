# assignmnent_viking_analytics

Anne Richardson

## Queries 1: Warmups

Many of the supplied query names were not present in my seeded data. For this reason, I used a modified data to yield some result from by database.

1. Get a list of all users in California
```
SELECT *
FROM users u JOIN states s ON s.id = u.state_id
WHERE s.name = 'Nebraska';
```
2. Get a list of all airports in Minnesota
```
SELECT *
FROM airports a
  JOIN states s ON a.state_id = s.id
WHERE s.name LIKE 'Minnesota';
```
3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```
SELECT DISTINCT payment_method
FROM users u
  JOIN itineraries i ON u.id = i.user_id
WHERE u.email = 'lueilwitz.caesar@leffler.name';
```
4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
SELECT f.price
FROM flights f
  JOIN airports a ON f.origin_id = a.id
WHERE a.long_name LIKE 'Hiramfort Probably International Airport';
```
5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```
SELECT DISTINCT CONCAT(a.long_name, ' (', a.code, ')') AS "XRK Connections"
FROM airports a
  JOIN flights fo ON fo.origin_id = a.id
  JOIN flights fd ON fd.destination_id = a.id
WHERE fo.destination_id = (
  SELECT id FROM airports WHERE code = 'XRK')
 OR fd.origin_id = (
  SELECT id from airports WHERE code = 'XRK');
```
6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first).
```
WIP --

SELECT a.long_name
FROM users u
  JOIN itineraries i ON i.user_id = u.id
  JOIN tickets t ON t.itinerary_id = i.id
  JOIN flights f ON f.id = t.flight_id
  JOIN airports a ON a.id = f.origin_id
WHERE u.first_name = 'Marques' AND u.last_name = 'Keebler' AND f.departure_time > '2012-01-01';
```

## Queries 2: Adding in Aggregation

1. Find the top 5 most expensive flights that end in Nebraska.
```
SELECT al.name, f.departure_time, f.price
FROM flights f
  JOIN airports a ON f.destination_id = a.id
  JOIN states s ON a.state_id = s.id
  JOIN airlines al ON f.airline_id = al.id
WHERE s.name = 'Nebraska'
ORDER BY f.price DESC
LIMIT 5;
```
2. Find the shortest flight that username "gaetano_moore" took.
```
SELECT al.name, (f.arrival_time - f.departure_time) AS time
FROM flights f
  JOIN airports a ON f.destination_id = a.id
  JOIN tickets t ON t.flight_id = f.id
  JOIN itineraries i ON t.itinerary_id = i.id
  JOIN users u ON i.user_id = u.id
  JOIN airlines al ON f.airline_id = al.id
WHERE u.username = 'gaetano_moore'
ORDER BY time ASC
LIMIT 1;
```
3. Find the average flight distance for flights entering or leaving each city in Florida
SELECT ROUND(AVG(f.distance)) AS avg_flight_distance
FROM flights f
  JOIN airports ao ON ao.id = f.origin_id
  JOIN states so ON so.id = ao.state_id
  JOIN airports ad ON ad.id = f.destination_id
  JOIN states sd ON sd.id = ad.state_id
WHERE so.name = 'Florida' OR sd.name = 'Florida';

4. Find the 3 users who spent the most money on flights in 2013
```
SELECT u.username, SUM(f.price)
FROM users u
  JOIN itineraries i ON i.user_id = u.id
  JOIN tickets t ON t.itinerary_id = i.id
  JOIN flights f ON t.flight_id = f.id
WHERE f.departure_time > '2012-01-01' AND f.departure_time < '2014-01-01'
GROUP BY u.username
ORDER BY SUM(f.price) DESC
LIMIT 3;
```
5. Count all flights to or from the city of Meggiemouth that did not land in Florida
```
SELECT COUNT(*)
FROM flights f
  JOIN airports ao ON ao.id = f.origin_id
  JOIN cities co ON ao.city_id = co.id
  JOIN airports ad ON ad.id = f.destination_id
  JOIN cities cd ON ad.city_id = cd.id
  JOIN states s ON ad.state_id = s.id
WHERE (co.name = 'Meggiemouth' OR cd.name = 'Meggiemouth') AND s.name != 'Florida';
```
6. Return the range of lengths of flights in the system(the maximum, and the minimum).
```
SELECT MAX(distance), MIN(distance)
FROM flights;
```

## Queries 3: Advanced

1. Find the most popular travel destination for users who live in Kansas.

2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.

3. Find the cheapest flight that was taken by a user who only had one itinerary.

4. Find the average cost of a flight itinerary for users in each state in 2012.

5. Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.
