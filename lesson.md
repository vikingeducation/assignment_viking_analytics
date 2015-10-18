## Viking Flight Planner

### Getting Started



### Warmups

Here are some queries we'd like you to answer using this ActiveRecord database. Remember, you can write your own queries using the **ModelName.find_by_sql** method.

1. Get a list of all users in California
```
SELECT * 
  FROM Users JOIN States ON States.id = Users.state_id 
  WHERE States.name = 'California'
```

2. Get a list of all airports in Minnesota
```
SELECT Airports.long_name
  FROM States JOIN Airports ON States.id = Airports.state_id
  WHERE States.name = 'Minnesota'
``` 

3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```
SELECT Itineraries.payment_method
  FROM Users JOIN Itineraries ON Users.id = Itineraries.user_id
  WHERE Users.email = 'heidenreich_kara@kunde.net'
```  

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
SELECT Flights.price
  FROM Flights JOIN Airports ON Flights.origin_id = Airports.id
  WHERE Airports.long_name = 'Edisonmouth Probably International Airport'
```

5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```
SELECT DISTINCT Airports.code, Airports.long_name
  FROM Flights LEFT JOIN Airports ON Flights.origin_id = Airports.id
  WHERE (Flights.origin_id = (SELECT Airports.id FROM Airports WHERE Airports.code = 'TDE')
  OR Flights.destination_id = (SELECT Airports.id FROM Airports WHERE Airports.code = 'TDE'))
  AND Airports.code != 'TDE'
```

6. Get a list of all airports visited by user Danny D'Amore after January 1, 2015. (Hint, see if you can get a list of all ticket IDs first).
```
SELECT DISTINCT Airports.long_name 
FROM Airports, (
  SELECT Flights.Origin_id, Flights.destination_id, Flights.arrival_time
  FROM Users JOIN Itineraries ON Users.id = Itineraries.user_id
  JOIN Tickets ON Itineraries.id = Tickets.itinerary_id
  JOIN Flights ON Tickets.flight_id = Flights.id
  WHERE Users.first_name = 'Dayna' 
  AND Users.last_name = 'Kozey' ) as User_flights

WHERE User_flights.arrival_time >= '2012-01-01' AND
Airports.id IN (User_flights.origin_id, User_flights.destination_id)
```


### JOIN and Aggregate
1. Find the top 5 most expensive flights that end in California.
```
SELECT Flights.price
FROM Flights JOIN Airports ON Flights.destination_id = Airports.id
JOIN States ON Airports.state_id = States.id
WHERE States.name = 'California'
ORDER BY Flights.price DESC
LIMIT 5
```

2. Find the shortest flight that username "ryann_anderson" took.
```
SELECT MIN(Flights.arrival_time - Flights.departure_time) AS shortest_flight
  FROM Users JOIN Itineraries ON Users.id = Itineraries.user_id
             JOIN Tickets ON Itineraries.id = Tickets.itinerary_id
             JOIN Flights ON Tickets.flight_id = Flights.id
  WHERE Users.username = 'estrella'
```

3. Find the average flight distance for every city in Florida
```
SELECT ROUND(AVG(Flights.distance),0) as avg_dist
FROM Flights JOIN Airports ON Airports.id = Flights.destination_id OR 
                              Airports.id = Flights.origin_id
             JOIN States ON Airports.state_id = States.id
WHERE States.name = 'Florida'
```

4. Find the 3 users who spent the most money on flights in 2013
```
SELECT DISTINCT Users.username, SUM(Flights.price) as Total_spent
  FROM Users JOIN Itineraries ON Users.id = Itineraries.user_id
             JOIN Tickets ON Itineraries.id = Tickets.itinerary_id
             JOIN Flights ON Tickets.flight_id = Flights.id
  WHERE Flights.departure_time >= '2013-01-01' AND Flights.departure_time < '2014-01-01'
  GROUP BY Users.username
  ORDER BY Total_spent DESC
  LIMIT 3
```

5. Count all flights to OR from the city of Lake Vivienne that did not land in Florida
```
SELECT DISTINCT COUNT(*) as Num_flights
FROM Flights JOIN Airports ON Airports.id = Flights.destination_id OR
                              Airports.id = Flights.origin_id
             JOIN Cities   ON Airports.city_id = Cities.id
WHERE Cities.name = 'DuBuqueburgh' 
AND Flights.destination_id NOT IN (SELECT Airports.id
                                   FROM Airports JOIN States ON Airports.state_id = States.id
                                   WHERE States.name = 'Florida')
AND Flights.origin_id NOT IN (SELECT Airports.id
                              FROM Airports JOIN States ON Airports.state_id = States.id
                              WHERE States.name = 'Florida')
```


6. Return the range of lengths of flights in the system(the maximum, and the minimum).
```
SELECT MAX(Flights.distance) as Longest_flight, MIN(Flights.distance) as Shortest_flight
FROM Flights
```



### Wrapping Up


