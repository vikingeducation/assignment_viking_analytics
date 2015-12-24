# assignmnent_viking_analytics

by Sia Karamalegos

## Warmups

**Get a list of all users in California**
```
SELECT u.username
FROM users u JOIN states s ON s.id = u.state_id
WHERE s.name = 'California';
```

**Get a list of all airports in Minnesota**
```
SELECT a.code, a.long_name
FROM airports a JOIN states s ON s.id = a.state_id
WHERE s.name = 'Minnesota';
```

**Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"** (use janae.zulauf@hermiston.biz for my dbase)
```
SELECT DISTINCT i.payment_method
FROM itineraries i JOIN users u ON u.id = i.user_id
WHERE u.email = 'heidenreich_kara@kunde.net';
```

**Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport** (use Edisonmouth instead)
```
SELECT f.price
FROM flights f JOIN airports a ON f.origin_id = a.id
WHERE a.long_name = 'Edisonmouth Probably International Airport';
```

**Find a list of all Airport names and codes which connect to the airport coded LYT.** (Use TDE instead)
```
SELECT DISTINCT a.code, a.long_name
FROM airports a
  JOIN flights of ON of.origin_id = a.id
  JOIN flights df ON df.destination_id = a.id
WHERE of.destination_id = (
    SELECT id FROM airports WHERE code = 'TDE')
  OR df.origin_id = (
    SELECT id FROM airports WHERE code = 'TDE');
```

**Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.**
```
SELECT a.long_name
FROM users u
  JOIN itineraries i ON i.user_id = u.id
  JOIN tickets t ON t.itinerary_id = i.id
  JOIN (SELECT id, origin_id as airport_id, departure_time as time FROM flights UNION SELECT id, destination_id as airport_id, arrival_time as time FROM flights) f ON f.id = t.flight_id
  JOIN airports a ON a.id = f.airport_id
WHERE u.first_name = 'Dannie' AND u.last_name = 'D''Amore' AND f.time > '2012-01-01';
```

## Adding in Aggregation

**Find the top 5 most expensive flights that end in California.**
```
SELECT f.id, f.price
FROM flights f
  JOIN airports a ON f.destination_id = a.id
  JOIN states s ON a.state_id = s.id
WHERE s.name = 'California'
ORDER BY price DESC
LIMIT 5;
```

**Find the shortest flight that username "ryann_anderson" took.**
```
SELECT MIN(f.distance)
FROM flights f
  JOIN tickets t ON t.flight_id = f.id
  JOIN itineraries i ON i.id = t.itinerary_id
  JOIN users u on u.id = i.user_id
WHERE username = 'ryann_anderson';
```

**Find the average flight distance for every city in Florida**
```
SELECT c.name, s.name, AVG(f.distance)
FROM cities c
  JOIN airports a ON a.city_id = c.id
  JOIN states s ON s.id = a.state_id
  JOIN (
    SELECT id, origin_id as airport_id, distance FROM flights
      UNION
    SELECT id, destination_id as airport_id, distance FROM flights) f ON f.airport_id = a.id
WHERE s.name = 'Florida'
GROUP BY c.name, s.name;
```

**Find the 3 users who spent the most money on flights in 2013**
```
SELECT u.username, SUM(f.price) as total_spent
FROM flights f
  JOIN tickets t ON t.flight_id = f.id
  JOIN itineraries i ON i.id = t.itinerary_id
  JOIN users u ON u.id = i.user_id
GROUP BY u.username
ORDER BY total_spent DESC LIMIT 3;
```

**Count all flights to OR from the city of Lake Vivienne that did not land in Florida** (Oregon already isn't Florida?)
```
SELECT f.id
FROM flights f
WHERE f.origin_id IN (
    SELECT a.id FROM airports a JOIN cities c ON a.city_id = c.id WHERE c.name = 'Lake Vivienne')
  AND f.destination_id IN (
    SELECT a.id FROM airports a JOIN states s ON a.state_id = s.id WHERE s.name != 'Florida');
```

**Return the range of lengths of flights in the system(the maximum, and the minimum).**
```
SELECT MIN(distance), MAX(distance) FROM flights;
```

## Advanced

**Find the most popular travel destination for users who live in Kansas.**
```
SELECT c.name
FROM cities c
  JOIN airports a ON a.city_id = c.id
  JOIN flights f ON f.destination_id = a.id
  JOIN tickets t ON t.flight_id = f.id
  JOIN itineraries i ON i.id = t.itinerary_id
  JOIN users u ON u.id = i.user_id
  JOIN states s ON s.id = u.state_id
WHERE s.name = 'Kansas'
GROUP BY c.name
ORDER BY COUNT(i.id) DESC LIMIT 1;
```

**How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.**
```
SELECT count(f.id)
FROM flights f
  JOIN flights fr ON f.origin_id = fr.destination_id
WHERE f.destination_id = fr.origin_id
  AND f.arrival_time < fr.departure_time;
```

**Find the cheapest flight that was taken by a user who only had one itinerary.**
```
SELECT MIN(f.price)
FROM flights f
  JOIN tickets t ON t.flight_id = f.id
  JOIN itineraries i ON i.id = t.itinerary_id
  JOIN users u ON u.id = i.user_id
GROUP BY u.id
HAVING COUNT(i.id) = 1
ORDER BY MIN(f.price) LIMIT 1;
```

**Find the average cost of a flight itinerary for users in each state in 2012.**
```
SELECT s.name, AVG(it.cost)
FROM states s
  JOIN users u ON u.state_id = s.id
  JOIN itineraries i ON u.id = i.user_id
  JOIN (
    SELECT i.id, SUM(f.price) as cost
    FROM flights f
      JOIN tickets t ON t.flight_id = f.id
      JOIN itineraries i ON i.id = t.itinerary_id
    GROUP BY i.id) as it ON it.id = i.id
GROUP BY s.id;
```

**Bonus:** You're a tourist. It's May 6, 2013 (change to 2011). Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.

All flights first leg:
```
SELECT f.id, f.price, f.arrival_time FROM flights f WHERE f.origin_id IN (SELECT a.id FROM airports a JOIN states s ON s.id = a.state_id WHERE s.name = 'Oregon') AND f.destination_id IN (SELECT a.id FROM airports a JOIN states s ON s.id = a.state_id WHERE s.name = 'Pennsylvania') AND f.departure_time > '2011-05-06' AND f.departure_time < '2011-06-17' AND f.distance <= 400;
```

All flights second leg:
```
SELECT f.id, f.price, f.arrival_time, 1 FROM flights f WHERE f.origin_id IN (SELECT a.id FROM airports a JOIN states s ON s.id = a.state_id WHERE s.name = 'Pennsylvania') AND f.destination_id IN (SELECT a.id FROM airports a JOIN states s ON s.id = a.state_id WHERE s.name = 'Arkansas') AND f.departure_time > '2011-05-06' AND f.departure_time < '2011-06-17' AND f.distance <= 400;
```

Final Query, ignoring start date, end date, and distance requirements so that I actually have data left:
```
SELECT *, (leg1.price + leg2.price) as total_price
FROM (
  SELECT f.id, f.price, f.arrival_time, 1 as match
  FROM flights f
  WHERE f.origin_id IN (
      SELECT a.id
      FROM airports a
        JOIN states s ON s.id = a.state_id
      WHERE s.name = 'Oregon')
    AND f.destination_id IN (
      SELECT a.id
      FROM airports a
        JOIN states s ON s.id = a.state_id
      WHERE s.name = 'Pennsylvania')) leg1
  JOIN (
    SELECT f.id, f.price, f.departure_time, 1 as match
    FROM flights f
    WHERE f.origin_id IN (
        SELECT a.id
        FROM airports a
          JOIN states s ON s.id = a.state_id
        WHERE s.name = 'Pennsylvania')
      AND f.destination_id IN (
        SELECT a.id
        FROM airports a
          JOIN states s ON s.id = a.state_id
        WHERE s.name = 'Arkansas')) leg2
    ON leg1.match = leg2.match
WHERE leg1.arrival_time < leg2.departure_time
ORDER BY total_price
LIMIT 1;
```

Final Query:
```
SELECT *, (leg1.price + leg2.price) as total_price
FROM (
  SELECT f.id, f.price, f.arrival_time, 1 as match
  FROM flights f
  WHERE f.origin_id IN (
      SELECT a.id
      FROM airports a
      JOIN states s ON s.id = a.state_id
      WHERE s.name = 'Oregon')
    AND f.destination_id IN (
      SELECT a.id
      FROM airports a
        JOIN states s ON s.id = a.state_id
      WHERE s.name = 'Pennsylvania')
        AND f.departure_time > '2011-05-06'
        AND f.departure_time < '2011-06-17'
        AND f.distance <= 400) leg1
  JOIN (
    SELECT f.id, f.price, f.departure_time, 1 as match
    FROM flights f
    WHERE f.origin_id IN (
        SELECT a.id
        FROM airports a
          JOIN states s ON s.id = a.state_id
        WHERE s.name = 'Pennsylvania')
      AND f.destination_id IN (
        SELECT a.id
        FROM airports a
          JOIN states s ON s.id = a.state_id
        WHERE s.name = 'Arkansas')
          AND f.departure_time > '2011-05-06'
          AND f.departure_time < '2011-06-17'
          AND f.distance <= 400) leg2
    ON leg1.match = leg2.match
WHERE leg1.arrival_time < leg2.departure_time
ORDER BY total_price
LIMIT 1;
```

*Merge origin and destination airport ids:*
SELECT id, origin_id as airport_id FROM flights UNION SELECT id, destination_id as airport_id FROM flights;
