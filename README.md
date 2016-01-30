# assignmnent_viking_analytics

User.find_by_sql("SELECT * FROM users JOIN states ON states.id=state_id WHERE states.name = 'California'")

Airport.find_by_sql("SELECT airports.long_name FROM airports JOIN states ON state_id=states.id WHERE states.name = 'Minnesota'")

Itinerary.find_by_sql("SELECT itineraries.payment_method FROM itineraries JOIN users ON itineraries.user_id=users.id WHERE email = 'heidenreich_kara@kunde.net'")

Flight.find_by_sql("SELECT flights.price FROM flights JOIN airports ON airports.id=origin_id WHERE long_name='Kochfurt Probably International Airport'")

Airport.find_by_sql("
SELECT airports.long_name, airports.code
  FROM (  SELECT flights.destination_id
        FROM airports
        JOIN flights
          ON flights.origin_id=airports.id
        WHERE airports.code = 'LYT' ) AS connections
  JOIN airports
    ON connections.destination_id=airports.id
  WHERE airports.code != 'LYT'")

Airport.find_by_sql("
  SELECT airports.long_name
    FROM ( SELECT tickets.id
          FROM tickets
          JOIN itineraries
            ON tickets.itinerary_id=itineraries.id
          JOIN users
            ON itineraries.user_id=users.id
          WHERE users.first_name = 'Dannie'
            AND users.last_name LIKE 'D%Amore') AS dd_tickets
    JOIN flights ON tickets.flight_id=flights.id
    JOIN airports ON flights.origin_id=airports.id
")
