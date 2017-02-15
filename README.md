# assignmnent_viking_analytics

Anthony Sin

## Queries 1: Warmups

1. Get a list of all users in California.

    ```
    User.find_by_sql("SELECT * FROM users WHERE state_id = 5;")
    ```
2. Get a list of all airports in Minnesota.

    ```
    Airport.find_by_sql("SELECT * FROM airports WHERE state_id = 23;") 
    ```
3. Get a list of all payment methods used on itineraries by the user with email address "runolfsdottir.stuart@white.org".

    ```
    Itinerary.find_by_sql("
      SELECT itineraries.payment_method 
        FROM itineraries 
        JOIN users ON itineraries.user_id = users.id
        WHERE users.email = 'runolfsdottir.stuart@white.org';
    ")
    ```
4. Get a list of prices of all flights whose origins are in "West Cristopherview Probably International Airport".

    ```
    Flight.find_by_sql("
      SELECT flights.price 
        FROM flights
        JOIN airports ON flights.origin_id = airports.id
        WHERE airports.long_name = 'West Cristopherview Probably International Airport';
    ")
    ```
5. Find a list of all Airport names and codes which connect to the airport coded JGY.

    ```
    Airport.find_by_sql("
      SELECT airports.long_name, airports.code
        FROM airports
        JOIN flights ON flights.destination_id = airports.id
        WHERE airports.code = 'JGY';
    ")
    ```
6. Get a list of all airports visited by user Joshua O'Reilly after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "O'Reilly"... escaping in SQL is different from Ruby.

    ```
    Airport.find_by_sql("
      SELECT airports.long_name
        FROM airports
        JOIN flights ON flights.destination_id = airports.id
        JOIN tickets ON tickets.flight_id = flights.id
        JOIN itineraries ON tickets.itinerary_id = itineraries.id
        JOIN users ON itineraries.user_id = users.id
        WHERE users.first_name = 'Joshua' 
        AND users.last_name = 'O''Reilly' 
        AND flights.arrival_time > '2012-01-01';
    ")
    ```

## Queries 2: Adding in Aggregation

1. Find the top 5 most expensive flights that end in California.

    ```
    Flight.find_by_sql("
      SELECT flights.price
        FROM flights
        JOIN airports ON flights.destination_id = airports.id
        WHERE airports.city_id = 5
        ORDER BY flights.price DESC
        LIMIT 5;
    ")
    ```
2. Find the shortest flight that username "chanel_hammes" took.

    ```
    Flight.find_by_sql("
      SELECT MIN(flights.distance) AS ShortestFlight
        FROM flights
        JOIN tickets ON flights.id = tickets.flight_id
        JOIN itineraries ON tickets.itinerary_id = itineraries.id
        JOIN users ON itineraries.user_id = users.id
        WHERE users.username = 'chanel_hammes';
    ")
    ```
3. Find the average flight distance for flights entering or leaving each city in Florida

    ```
    Flight.find_by_sql("
      SELECT AVG(flights.distance) AS AverageDistance
        FROM flights
        JOIN airports ON flights.destination_id = airports.id OR flights.origin_id = airports.id
        WHERE airports.state_id = 9;
    ")
    ```
4. Find the 3 users who spent the most money on flights in 2013

    ```
    User.find_by_sql("
      SELECT  users.id, 
              users.username, 
              users.first_name, 
              users.last_name, 
              SUM(flights.price) AS MoneySpent2013
        FROM users
        JOIN itineraries ON users.id = itineraries.user_id
        JOIN tickets ON itineraries.id = tickets.itinerary_id
        JOIN flights ON tickets.flight_id = flights.id
        WHERE flights.departure_time BETWEEN '2013-01-01' AND '2013-12-31'
        GROUP BY users.id
        ORDER BY SUM(flights.price) DESC
        LIMIT 3;
    ")
    ```
5. Count all flights to or from the city of Wittingshire that did not land in Maine
    
    ```
    Flight.find_by_sql("
      SELECT COUNT(flights.*) AS CustomCount
        FROM flights
        JOIN airports ON flights.destination_id = airports.id OR flights.origin_id = airports.id
        JOIN cities ON airports.city_id = cities.id
        WHERE cities.name = 'Wittingshire'
        AND flights.destination_id IN (
          SELECT airports.id
            FROM airports 
            JOIN states ON airports.state_id = states.id
            WHERE states.name != 'Maine'
        );
    ")
    ```
6. Return the range of lengths of flights in the system(the maximum, and the minimum).
    
    ```
    Flight.find_by_sql("
      SELECT MIN(distance), MAX(distance)
        FROM flights;
    ")
    ```

## Queries 3: Advanced
1. Find the most popular travel destination for users who live in Kansas.

    ```
    User.find_by_sql("
      SELECT flights.destination_id, cities.name AS City, states.name AS State, COUNT(*) AS Count
        FROM users
        JOIN itineraries ON users.id = itineraries.user_id
        JOIN tickets ON itineraries.id = tickets.itinerary_id
        JOIN flights ON tickets.flight_id = flights.id
        JOIN airports ON flights.destination_id = airports.id
        JOIN cities ON airports.city_id = cities.id
        JOIN states ON airports.state_id = states.id
        WHERE users.state_id IN (
          SELECT id
            FROM states
            WHERE name = 'Kansas'
        )
        GROUP BY flights.destination_id, City, State
        ORDER BY Count DESC
        LIMIT 1;
    ")
    ```

2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.

    ```
    Flight.find_by_sql("
      SELECT Count(*) AS RoundTripCount
        FROM flights f1
        JOIN flights f2 ON f1.destination_id = f2.origin_id AND f1.origin_id = f2.destination_id  
        WHERE f1.arrival_time < f2.departure_time   
    ")
    ```

3. Find the cheapest flight that was taken by a user who only had one itinerary.

    ```
    User.find_by_sql("
      SELECT users.id, users.username, MIN(flights.price) as CheapestFlight
        FROM users
        JOIN itineraries ON users.id = itineraries.user_id
        JOIN tickets ON itineraries.id = tickets.itinerary_id
        JOIN flights ON tickets.flight_id = flights.id
        GROUP BY users.id
        HAVING COUNT(itineraries.*) = 1;
    ")
    ```

4. Find the average cost of a flight itinerary for users in each state in 2012.

    ```
    Flight.find_by_sql("
      SELECT states.name, AVG(flights.price) AS AverageCost
        FROM users
        JOIN itineraries ON users.id = itineraries.user_id
        JOIN tickets ON itineraries.id = tickets.itinerary_id
        JOIN flights ON tickets.flight_id = flights.id
        JOIN airports ON flights.origin_id = airports.id
        JOIN cities ON airports.city_id = cities.id
        JOIN states ON airports.state_id = states.id
        WHERE flights.arrival_time BETWEEN '2012-01-01' AND '2012-12-31'
        AND flights.departure_time BETWEEN '2012-01-01' AND '2012-12-31'
        GROUP BY states.name
        ORDER BY AverageCost ASC;
    ")
    ```

5. Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.

    ```
    Flight.find_by_sql("
      SELECT *
        FROM flights
        JOIN airports ON flights.origin_id = airports.id OR flights.destination_id = airports.id
        JOIN states ON airports.state_id = states.id
        WHERE states.name IN ('Oregon', 'Pennsylvania', 'Arkansas')
        AND flights.distance <= 400
        AND flights.arrival_time BETWEEN '2013-05-06' AND '2013-06-17'
        AND flights.departure_time BETWEEN '2013-05-06' AND '2013-06-17'
    ")
    ```