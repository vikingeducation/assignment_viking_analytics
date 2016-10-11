# assignmnent_viking_analytics

Tamal Riedman

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
