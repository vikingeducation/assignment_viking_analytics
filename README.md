Assignment completed by [Stephen Mayeux](http://stephenmayeux.com)

# assignmnent_viking_analytics

## Warmups

1. Get a list of all users in California

``` sql
SELECT *
  FROM users
  JOIN states ON users.state_id = states.id
  WHERE states.name = 'California'
```

2. Get a list of all airports in Minnesota

``` sql
SELECT *
  FROM airports
  JOIN states ON airports.state_id = states.id
  WHERE states.name = 'Minnesota'
```

3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"

``` sql
SELECT *
  FROM users
  JOIN itineraries
  ON users.id = itineraries.user_id
  WHERE users.email = 'heidenreich_kara@kunde.net'
```

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.

``` sql
SELECT price
  FROM flights
  JOIN airports
  ON flights.origin_id = airports.id
  WHERE airports.long_name = 'Kochfurt Probably International Airport'
```

5. Find a list of all Airport names and codes which connect to the airport coded LYT.

``` sql
SELECT destination.long_name, destination.code
  FROM flights
  JOIN airports origin
  ON flights.origin_id = origin.id
  JOIN airports destination
  ON flights.destination_id = destination.id
  WHERE destination.code = 'LYT'
```

6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012.

``` sql
SELECT *
  FROM itineraries
  JOIN users users
  ON itineraries.user_id = users.id
  JOIN tickets tickets
  ON itineraries.id = tickets.itinerary_id
  JOIN flights flights
  ON tickets.flight_id = flights.
  JOIN airports airports
  WHERE users.first_name = 'Stone'
```

## Section 2

1. Find the top 5 most expensive flights that end in California.

``` sql
SELECT flights.*
  FROM flights
  JOIN states states
  ON flights.destination_id = states.id
  WHERE states.name = 'California'
  ORDER BY flights.price DESC
  LIMIT 5
```
