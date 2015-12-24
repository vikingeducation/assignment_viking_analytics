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

*Merge origin and destination airport ids:*
SELECT id, origin_id as airport_id FROM flights UNION SELECT id, destination_id as airport_id FROM flights;
