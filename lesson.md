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
  /* Use LEFT JOIN to keep all data in the flights table, might not be needed */
  FROM Flights LEFT JOIN Airports ON Flights.origin_id = Airports.id
  /* Subqueries to get the Airport ID of TDE, then we filter on any flights coming into or out of TDE */
  WHERE (Flights.origin_id = (SELECT Airports.id FROM Airports WHERE Airports.code = 'TDE')
  OR Flights.destination_id = (SELECT Airports.id FROM Airports WHERE Airports.code = 'TDE'))
  /* Don't include TDE itself in the results */
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





### Wrapping Up


