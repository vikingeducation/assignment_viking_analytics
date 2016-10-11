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
