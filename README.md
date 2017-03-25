Dariusz Biskupski
# assignmnent_viking_analytics

#Queries 1: Warmups

1. Get a list of all users in California
User.find_by_sql("SELECT * FROM users JOIN states ON users.state_id = states.id WHERE name = 'California'")

+----+---------+----------+----------------+------------+------------+--------------------+--------------------+--------------------+------------+
| id | city_id | state_id | username       | first_name | last_name  | email              | created_at         | updated_at         | name       |
+----+---------+----------+----------------+------------+------------+--------------------+--------------------+--------------------+------------+
| 5  | 16      | 5        | zella.schmeler | Easton     | Rutherford | rutherford.east... | 2017-03-23 20:0... | 2017-03-23 20:0... | California |
+----+---------+----------+----------------+------------+------------+--------------------+--------------------+--------------------+------------+


2. Get a list of all airports in Minnesota
Airport.find_by_sql("SELECT * FROM airports JOIN states ON airports.state_id = states.id WHERE name = 'Minnesota'")
  Airport Load (2.1ms)  SELECT * FROM airports JOIN states ON airports.state_id = states.id WHERE name = 'Minnesota'
+----+---------+----------+------+---------------------------------------------+-------------------------+-------------------------+-----------+
| id | city_id | state_id | code | long_name                                   | created_at              | updated_at              | name      |
+----+---------+----------+------+---------------------------------------------+-------------------------+-------------------------+-----------+
| 23 | 2       | 23       | GMO  | Franzborough Probably International Airport | 2017-03-23 20:08:42 UTC | 2017-03-23 20:08:42 UTC | Minnesota |
+----+---------+----------+------+---------------------------------------------+-------------------------+-------------------------+-----------+



3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"

Itinerary.find_by_sql("SELECT itineraries.payment_method FROM itineraries JOIN users ON (itineraries.user_id=users.id) WHERE users.email='heidenreich_kara@kunde.net'")



Itinerary.find_by_sql("SELECT itineraries.payment_method FROM itineraries JOIN users ON (itineraries.user_id=users.id) WHERE users.email='bosco_filomena@klein.co'")

4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
Flight.find_by_sql("SELECT flights.price FROM flights JOIN airports ON (flights.origin_id = airports.id) WHERE airports.long_name='Kochfurt Probably International Airport'")

5. Find a list of all Airport names and codes which connect to the airport coded LYT.

Airport.find_by_sql("SELECT airports.long_name, airports.code FROM airports JOIN flights ON (flights.origin_id = airports.id) WHERE flights.destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'LYT' )")

Airport.find_by_sql("SELECT airports.long_name, airports.code FROM airports JOIN flights ON (flights.origin_id = airports.id) WHERE flights.destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'GBC' )")

6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.

Airport.find_by_sql("SELECT airports.long_name 
FROM airports 
JOIN flights ON (flights.origin_id = airports.id) 
JOIN users ON (flights.) 
JOIN tickets ON
JOIN itineraries ON 
WHERE .destination_id = (SELECT airports.id FROM airports WHERE airports.code = 'GBC' )")
