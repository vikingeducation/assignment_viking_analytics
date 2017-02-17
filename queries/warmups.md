1. Get a list of all users in California  

```
User.find_by_sql("SELECT * FROM users JOIN states ON users.state_id = states.id WHERE states.name = 'California'")
```

2. Get a list of all airports in Minnesota

```
Airport.find_by_sql "SELECT * FROM airports JOIN states ON airports.state_id = states.id WHERE states.name = 'Minnesota'"
```

3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"

```
Itinerary.find_by_sql "SELECT * FROM itineraries JOIN users ON itineraries.user_id = users.id WHERE users.email = 'heidenreich_kara@kunde.net'"
```

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.

```
Flight.find_by_sql "SELECT * FROM flights JOIN airports a1 ON flights.origin_id = a1.id JOIN airports a2 ON flights.destination_id = a2.id WHERE a1.long_name = 'New Marlinfurt Probably International Airport'"
```

5. Find a list of all Airport names and codes which connect to the airport coded LYT.

```
Flight.find_by_sql "SELECT * FROM flights JOIN airports a1 ON flights.origin_id = a1.id JOIN airports a2 ON flights.destination_id = a2.id WHERE a1.code = 'LYT' OR a2.code = 'LYT'"
```

6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.

```
Ticket.find_by_sql "SELECT * FROM tickets JOIN itineraries ON itineraries.id = tickets.itinerary_id JOIN users on users.id = itineraries.user_id JOIN flights ON flights.id = flight_id WHERE users.first_name = 'Dannie' AND users.last_name = 'D''Amore' AND departure_time > '2012-01-01'"
```