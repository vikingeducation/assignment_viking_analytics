## Viking Flight Planner

### Getting Started



### Queries 1 - Warmups

Here are some queries we'd like you to answer using this ActiveRecord database. Remember, you can write your own queries using the **ModelName.find_by_sql** method.

1. Get a list of all users in California

```
SELECT *
  FROM users JOIN states
    ON state_id=states.id
  WHERE states.name='California';
```

2. Get a list of all airports in Minnesota

```
SELECT states.name AS state,long_name AS airport
  FROM airports JOIN states
    ON state_id=states.id
  WHERE states.name='Minnesota';
```
3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"

```
SELECT payment_method, email
  FROM itineraries RIGHT JOIN users
    ON user_id=users.id
  WHERE users.email='heidenreich_kara@kunde.net';
```

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.

```
SELECT price, long_name
  FROM flights JOIN airports
    ON origin_id=airports.id
  WHERE long_name='Kochfurt Probably International Airport';
```

5. Find a list of all Airport names and codes which connect to the airport coded LYT.

```
SELECT O.long_name AS origin, O.code AS orig_code,
  D.long_name AS destination, D.code AS dest_code
  FROM flights JOIN airports O
    ON origin_id=O.id
  JOIN airports D
    ON destination_id = D.id
  WHERE O.code='LYT' OR D.code='LYT';
```

6. Get a list of all airports visited by user Danny D'Amore after January 1, 2015. (Hint, see if you can get a list of all ticket IDs first). (MODIFIED SINCE DATABASE SEED DOESN'T CONTAIN THIS USER, LOOKED FOR USER: Ivy Volkman, DATE after January 1, 2010)

```
SELECT last_name, first_name, long_name, arrival_time, departure_time
  FROM tickets JOIN itineraries ON itinerary_id=itineraries.id
  JOIN users ON user_id=users.id
  JOIN flights ON flight_id=flights.id
  JOIN airports ON airports.id IN (origin_id, destination_id)
  WHERE first_name='Ivy' AND last_name='Volkman'
  AND (arrival_time > '2011-01-01' OR departure_time > '2011-01-01')
```

### Queries 2 - Adding in Aggregation

1. Find the top 5 most expensive flights that end in California.

```
SELECT *
  FROM flights JOIN airports ON destination_id=airports.id
  JOIN states ON state_id=states.id
  WHERE name='California'
  ORDER BY price DESC
  LIMIT 5
```

2. Find the shortest flight that username "ryann_anderson" took. (username='scarlett_purdy' for this DB seed)

```
SELECT *
  FROM tickets JOIN itineraries ON itinerary_id=itineraries.id
  JOIN flights ON flight_id=flights.id
  JOIN users ON user_id=users.id
  WHERE username='scarlett_purdy'
  ORDER BY distance DESC
  LIMIT 1
```

3. Find the average flight distance for every city in Florida

```
SELECT ROUND(AVG(distance)), cities.name
  FROM flights JOIN airports ON airports.id IN (origin_id, destination_id)
  JOIN states ON state_id=states.id
  JOIN cities ON city_id=cities.id
  WHERE states.name='Florida'
  GROUP BY cities.name

--QUERIES DONT WORK BECAUSE SEED CREATES INDICES FOR CITIES THAT DON'T EXIST!!!

SELECT ROUND(AVG(distance)), OC.name
  FROM flights JOIN airports AS O ON origin_id=O.id
  	JOIN states AS OS ON O.state_id=OS.id
  	JOIN cities AS OC ON O.city_id=OC.id
  JOIN airports AS D ON destination_id=D.id
  	JOIN states AS DS ON D.state_id=DS.id
  	JOIN cities AS DC ON D.city_id=DC.id
  WHERE OS.name='Florida' OR DS.name='Florida'
  GROUP BY OC.name, DC.name
```

4. Find the 3 users who spent the most money on flights in 2013

```
SELECT users.last_name, users.first_name, SUM(price)
  FROM users JOIN itineraries ON users.id=user_id
  JOIN tickets ON itineraries.id=itinerary_id
  JOIN flights ON flight_id=flights.id
  WHERE (departure_time BETWEEN '2013-01-01' AND '2013-12-31')
  OR (arrival_time BETWEEN '2013-01-01' AND '2013-12-31')
  GROUP BY users.last_name, users.first_name
  ORDER BY SUM(price) DESC
  LIMIT 3
```

5. Count all flights to or from the city of Lake Vivienne that did not land in Florida (used another city 'South Ollie' instead of Lake Vivienne)

```
SELECT *
  FROM flights JOIN airports ON airports.id IN (origin_id, destination_id)
  JOIN cities ON city_id=cities.id

SELECT *
  FROM flights JOIN airports AS O ON origin_id=O.id
    JOIN cities AS OC ON O.city_id=OC.id
  JOIN airports AS D ON destination_id=D.id
    JOIN cities AS DC ON D.city_id=DC.id

```

6. Return the range of lengths of flights in the system(the maximum, and the minimum).



### Wrapping Up
