# assignmnent_viking_analytics
<br>
Mariah Schneeberger
<br>

Queries 1: Warmups
  #1 SELECT username
        FROM users
        JOIN states
          ON users.state_id = states.id
      WHERE states.name LIKE 'California';

  #2 SELECT long_name
        FROM airports
        JOIN states
          ON airports.state_id = states.id
      WHERE states.name LIKE 'Minnesota';

  #3 SELECT payment_method
        FROM itineraries
        JOIN users
          ON users.id = itineraries.user_id
      WHERE users.email LIKE 'heidenreich_kara@kunde.net';

  #4 SELECT price
         FROM flights
         JOIN airports
           ON flights.origin_id = airports.id
       WHERE airports.long_name LIKE ' Kochfurt Probably International Airport';

  #5 SELECT code
         FROM airports
       WHERE id IN (SELECT flights.destination_id
                        FROM airports
                        JOIN flights
                          ON flights.origin_id = airports.id
                      WHERE flights.origin_id = (SELECT id
                                                     FROM airports
                                                   WHERE code LIKE 'ZAZ'))
          OR id IN (SELECT flights.origin_id  
                        FROM flights
                        JOIN airports a
                          ON flights.destination_id = a.id
                      WHERE flights.destination_id = (SELECT id
                                                          FROM airports
                                                        WHERE code LIKE 'ZAZ'));

  #6  SELECT long_name
          FROM airports
        WHERE id IN (SELECT origin_id
                         FROM flights
                       WHERE departure_time > '2012-01-01 00:00:00' AND id IN (SELECT id as flight_id
                                        FROM flights
                                      WHERE id IN (SELECT flight_id
                                                       FROM tickets
                                                     WHERE itinerary_id IN (SELECT id
                                                                                FROM itineraries
                                                                             WHERE user_id = (SELECT id
                                                                                                  FROM users
                                                                                                WHERE first_name LIKE 'Dannie' AND last_name LIKE 'D''Amore)))))



        OR id IN (SELECT origin_id
                      FROM flights
                    WHERE id IN (SELECT id as flight_id
                                     FROM flights
                                   WHERE departure_time > '2012-01-01 00:00:00' AND id IN (SELECT flight_id
                                                    FROM tickets
                                                  WHERE itinerary_id IN (SELECT id
                                                                             FROM itineraries
                                                                           WHERE user_id = (SELECT id
                                                                                                FROM users
                                                                                              WHERE first_name LIKE 'Dannie' AND last_name LIKE 'D''Amore')))));





Queries 2: Adding Aggregation

  #1 SELECT f.price, f.id
        FROM flights f
        JOIN airports a
          ON f.destination_id = a.id
        JOIN states s
          ON a.state_id = s.id
      WHERE s.name LIKE 'California'
      ORDER BY f.price DESC
      LIMIT 5;

  #2 SELECT MIN(distance) AS 'Shortest Flight Taken by ryann_anderson'
        FROM flights f
        JOIN tickets t
          ON f.id = t.flight_id
        JOIN itineraries i
          ON t.itinerary_id = i.id
        JOIN users u
          ON i.user_id = u.id
      WHERE u.username = 'ryann_anderson';

  #3 SELECT AVG(distance)                   
        FROM flights
      WHERE origin_id IN (SELECT a.id
                              FROM airports a
                              JOIN states s
                                ON a.state_id = s.id
                            WHERE s.name LIKE 'Florida')
         OR destination_id IN (SELECT a.id
                                   FROM airports a
                                   JOIN states s
                                     ON a.state_id = s.id
                                 WHERE s.name LIKE 'Florida');

  #4 SELECT username
        FROM users
        JOIN itineraries i
          ON users.id = i.user_id
        JOIN tickets t
          ON i.id = t.itinerary_id
        JOIN flights f
          ON t.flight_id = f.id
      GROUP BY username
      ORDER BY SUM(f.price)
      LIMIT 3;

  #5 SELECT COUNT(f.id)
        FROM flights f
      WHERE (origin_id = (SELECT airports.id
                              FROM airports
                              JOIN cities
                                ON airports.city_id = cities.id
                            WHERE cities.name LIKE 'Feiltown')
        AND destination_id NOT IN (SELECT airports.id
                                      FROM airports
                                      JOIN states
                                        ON airports.state_id = states.id
                                    WHERE states.name LIKE 'Florida'))
         OR destination_id = (SELECT airports.id
                                  FROM airports
                                  JOIN cities
                                    ON airports.city_id = cities.id
                                WHERE cities.name LIKE 'Feiltown');

  #6 SELECT MIN(distance) AS shortest_flights, MAX(distance) AS longest_flight
        FROM flights;


Queries 3: Advanced

  #1 SELECT cities.name
        FROM cities
        JOIN airports a
          ON cities.id = a.city_id
        JOIN flights
          ON a.id = flights.destination_id
        JOIN tickets t
          ON t.flight_id = flights.id
        JOIN itineraries i
          ON t.itinerary_id = i.id
        JOIN users
          ON i.user_id = users.id
      WHERE users.state_id = (SELECT id
                                  FROM states
                                WHERE name LIKE 'Kansas')
      GROUP BY cities.name
      ORDER BY COUNT(cities.name) DESC
      LIMIT 1;

  #2 I don't know.

  #3 SELECT MIN(price)
        FROM flights f
        JOIN tickets t
          ON f.id = t.flight_id
        WHERE t.itinerary_id IN (SELECT DISTINCT user_id
                                    FROM itineraries);

  #4 SELECT states.name, AVG(flights.price)             
        FROM flights
        JOIN tickets
          ON flights.id = tickets.flight_id
        JOIN itineraries
          ON tickets.itinerary_id = itineraries.id
        JOIN users
          ON itineraries.user_id = users.id
        JOIN states
          ON users.state_id = states.id
      GROUP BY states.name
      ORDER BY states.name;
