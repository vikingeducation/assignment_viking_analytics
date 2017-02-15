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

