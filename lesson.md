## Viking Flight Planner

### Getting Started



### Warmups

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

6. Get a list of all airports visited by user Danny D'Amore after January 1, 2015. (Hint, see if you can get a list of all ticket IDs first).

  ```
  SELECT first_name, tickets.id
    FROM tickets JOIN itineraries
      ON itinerary_id=itineraries.id
    JOIN users
      ON user_id=users.id
    WHERE first_name='Danny' AND last_name='D/'Amore';
  ```

### JOIN and Aggregate





### Wrapping Up
