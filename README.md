# assignmnent_viking_analytics

Tamal Riedman

Beginner
1.  SELECT username FROM users JOIN states ON state_id=states.id WHERE name='California';
2.  SELECT long_name FROM airports JOIN states ON state_id=states.id WHERE name='Minnesota';
3.  SELECT payment_method
    FROM itineraries JOIN users ON itineraries.user_id = users.id
    WHERE users.email='heidenreich_kara@kunde.net';
4.  SELECT price
    FROM flights JOIN airports ON origin_id=airports.id
    WHERE long_name='Kochfurt Probably International Airport';
5.  SELECT long_name, code
    FROM airports
    WHERE code='LYT';
6.  SELECT long_name, departure_time
    FROM tickets JOIN itineraries ON tickets.itinerary_id=itineraries.id
    JOIN users ON itineraries.user_id = users.id
    JOIN flights ON tickets.flight_id=flights.id
    JOIN airports ON airports.id=flights.origin_id
    WHERE users.first_name='Dannie' AND users.last_name='D''Amore' AND flights.departure_time>'2012-01-01';

Intermediate
1.  SELECT *
    FROM flights JOIN airports ON flights.destination_id = airports.id
    JOIN states ON airports.state_id = states.id
    WHERE states.name = 'California'
    ORDER BY price DESC
    LIMIT 5;
2.  SELECT distance, airline_id, origin_id, destination_id
    FROM flights JOIN tickets ON flights.id=tickets.flight_id
    JOIN itineraries ON tickets.itinerary_id=itineraries.id
    JOIN users ON users.id = itineraries.user_id
    WHERE username='ryann[_]anderson'
    ORDER BY distance
    LIMIT 1;
3.  SELECT AVG(distance)
    FROM
      (SELECT distance
      FROM flights JOIN airports ON flights.origin_id = airports.id
      JOIN states ON airports.state_id=states.id
      WHERE states.name='Florida'
      UNION
      SELECT distance
      FROM flights JOIN airports ON flights.destination_id=airports.id
      JOIN states ON states.id=airports.state_id
      WHERE states.name='Florida') AS joint_table;
4.  SELECT users.username, SUM(price) AS total_spent
    FROM flights JOIN tickets ON flights.id=tickets.flight_id
    JOIN itineraries ON tickets.itinerary_id=itineraries.id
    JOIN users ON users.id=itineraries.user_id
    WHERE flights.departure_time BETWEEN '2013-01-01' AND '2013-12-31'
    GROUP BY users.username
    ORDER BY total_spent DESC
    LIMIT 3;
5.  SELECT SUM(count) AS all_flights
    FROM
      (SELECT COUNT(flights.id)
      FROM flights JOIN airports ON flights.origin_id = airports.id
      JOIN cities ON airports.city_id = cities.id
      JOIN states ON airports.state_id = states.id
      WHERE cities.name = 'Lake Vivienne'
      AND flights.destination_id NOT IN
        (SELECT airports.id
        FROM airports JOIN states ON airports.state_id = states.id
        WHERE states.name = 'Florida')
      UNION
      SELECT COUNT(flights.id)
      FROM flights JOIN airports ON flights.destination_id = airports.id
      JOIN cities ON airports.city_id = cities.id
      JOIN states ON airports.state_id = states.id
      WHERE cities.name = 'Lake Vivienne'
      AND flights.origin_id NOT IN
        (SELECT airports.id
        FROM airports JOIN states ON airports.state_id = states.id
        WHERE states.name = 'Florida')) AS joint_table;
6.  SELECT MAX(distance), MIN(distance)
    FROM flights;

Advanced
1.  SELECT states.name, COUNT(states.name) AS num_travels
    FROM tickets
    JOIN flights ON tickets.flight_id=flights.id
    JOIN airports ON airports.id=flights.destination_id
    JOIN cities ON cities.id=airports.city_id
    JOIN states ON states.id=airports.state_id
    JOIN itineraries ON itineraries.id=tickets.itinerary_id
    JOIN users ON users.id=itineraries.user_id
    WHERE users.state_id=(SELECT states.id
                          FROM states
                          WHERE states.name='Kansas')
    GROUP BY states.name
    ORDER BY num_travels DESC;
2.  SELECT airports.long_name
    FROM
      (SELECT DISTINCT f1.origin_id, f1.destination_id
       FROM flights f1 JOIN flights f2
       ON f1.origin_id=f2.destination_id
       AND f1.destination_id=f2.origin_id
       WHERE f1.id <> f2.id
       ORDER BY f1.origin_id) AS joint_table
    JOIN airports ON airports.id=origin_id;
3.  SELECT flights.id, flights.price, users.first_name
    FROM flights JOIN tickets ON tickets.flight_id=flights.id
    JOIN itineraries ON itineraries.id=tickets.itinerary_id
    JOIN users ON itineraries.user_id=users.id
    WHERE users.username IN
      (SELECT users.username
       FROM tickets
       JOIN flights ON tickets.flight_id=flights.id
       JOIN itineraries ON itineraries.id=tickets.itinerary_id
       JOIN users ON users.id=itineraries.user_id
       GROUP BY users.username
       HAVING COUNT(itineraries)=1)
    ORDER BY flights.price
    LIMIT 1;
4.  SELECT AVG(flights.price), states.name AS states
    FROM flights
    JOIN tickets ON tickets.flight_id=flights.id
    JOIN itineraries ON itineraries.id=tickets.itinerary_id
    JOIN users ON users.id=itineraries.user_id
    JOIN states ON states.id=users.state_id
    WHERE flights.departure_time BETWEEN '2012-01-01' AND '2012-12-31'
    GROUP BY states.name;