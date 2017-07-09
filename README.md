# assignment_viking_analytics

Worked on by [Roy Chen](https://github.com/roychen25)

Queries 1: Warmups

1. Get a list of all users in California
```
SELECT *
FROM users
WHERE users.state_id =
  (SELECT id FROM states WHERE states.name='California');
```
2. Get a list of all airports in Minnesota
```
SELECT *
FROM airports
WHERE state_id =
 (SELECT id FROM states WHERE name = 'Minnesota');
```
3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```
SELECT *
FROM itineraries
WHERE user_id =
  (SELECT id FROM users WHERE email = 'heidenreich_kara@kunde.net');
```
4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
SELECT *
FROM flights
WHERE origin_id =
  (SELECT id FROM airports WHERE long_name LIKE 'Kochfurt%');
```
5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```
SELECT DISTINCT long_name, code
FROM flights JOIN airports ON destination_id =
  (SELECT id FROM airports WHERE code = 'LYT')
```
6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
```
SELECT flights.arrival_time, airports.long_name
FROM tickets
JOIN itineraries ON (tickets.itinerary_id = itineraries.id)
JOIN flights ON (tickets.flight_id = flights.id)
JOIN airports ON (flights.destination_id = airports.id)
WHERE user_id =
  -- id for user
	(SELECT id
	FROM users
	WHERE first_name ='Dannie'
	AND last_name = 'D''Amore')
AND flights.arrival_time > '2012-01-01'
```
