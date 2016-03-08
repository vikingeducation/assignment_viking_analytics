## Viking Flight Planner

### Getting Started

### Warmups

Here are some queries we'd like you to answer using this ActiveRecord database. Remember, you can write your own queries using the **ModelName.find_by_sql** method.

1. Get a list of all users in California

User.find_by_sql("SELECT * FROM users JOIN states ON users.state_id = states.id where states.name = 'California'")

2. Get a list of all airports in Minnesota

Airport.find_by_sql("SELECT * FROM airports JOIN states ON airports.state_id = states.id where states.name = 'Minnesota'")

3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"

User.find_by_sql("SELECT * FROM users JOIN itineraries ON itineraries.user_id = users.id where users.email = 'heidenreich_kara@kunde.net'")

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.

Flight.find_by_sql("SELECT * FROM flights JOIN airports ON flights.origin_id = airports.id WHERE airports.long_name ILIKE '%Kochfurt%'")

5. Find a list of all Airport names and codes which connect to the airport coded LYT.

Flight.find_by_sql("SELECT * FROM flights JOIN airports ON flights.origin_id = airports.id OR flights.destination_id = airports.id WHERE airports.code = 'LYT'")

6. Get a list of all airports visited by user Danny D'Amore after January 1, 2015. (Hint, see if you can get a list of all ticket IDs first).

User.find_by_sql("SELECT * FROM users JOIN itineraries ON users.id = itineraries.user_id JOIN tickets ON tickets.itinerary_id = itineraries.id JOIN flights ON tickets.flight_id = flights.id JOIN airports on flights.origin_id = airports.id OR flights.destination_id = airports.id WHERE users.first_name='Danny' AND users.last_name='D''Amore'")




