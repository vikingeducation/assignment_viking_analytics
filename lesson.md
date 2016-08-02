## Viking Flight Planner

### Getting Started



### Warmups

Here are some queries we'd like you to answer using this ActiveRecord database. Remember, you can write your own queries using the **ModelName.find_by_sql** method.

1. Get a list of all users in California
```sql
SELECT *
  FROM users JOIN states
  ON (states.id = users.state_id)
  WHERE states.name = 'California'
```
2. Get a list of all airports in Minnesota
```sql
SELECT *
FROM airports JOIN states
ON (airports.state_id = states.id)
WHERE states.name = 'Minnesota'
```
3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```sql
SELECT payment_method FROM users JOIN itineraries
ON (itineraries.user_id = users.id)
WHERE users.email = 'heidenreich_kara@kunde.net'
```
4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```sql
SELECT price FROM flights JOIN airports
ON (flights.origin_id = airports.id)
WHERE airports.long_name = 'Kochfurt Probably International Airport'
```
5. Find a list of all Airport names and codes which connect to the airport coded LYT.

6. Get a list of all airports visited by user Danny D'Amore after January 1, 2015. (Hint, see if you can get a list of all ticket IDs first).

### JOIN and Aggregate





### Wrapping Up
