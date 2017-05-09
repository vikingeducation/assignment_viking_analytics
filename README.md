# assignmnent_viking_analytics
---
Frank Yu
---

# Warmups
1. Get a list of all users in California
  User.find_by_sql("SELECT * FROM users JOIN states ON(users.state_id = states.id) WHERE states.name = 'California'")

2. Get a list of all airports in Minnesota
   

3. Get a list of all payment methods used on itineraries by the user with email address 'ryan.rahul@hayes.co'
     Itinerary.find_by_sql("SELECT itineraries.payment_method FROM itineraries JOIN users ON(itineraries.user_id = users.id) WHERE users.email = 'ryan.rahul@hayes.co'") 

*** 4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
    Flight.find_by_sql("SELECT price FROM flights JOIN airports ON(flights.origin_id = airports.id) WHERE airports.long_name = 'Kochfurt Probably International Airport'")

*** 5. Find a list of all Airport names and codes which connect to the airport coded JPY.
     Airport.find_by_sql("SELECT airports.long_name FROM airports JOIN flights ON(origin_id = airports.id) WHERE destination_id = (SELECT airports.id FROM airports WHERE code = 'DJQ')")

*** 6. Get a list of all airports visited by user Alec Hermann after January 1, 2012.
    Airport.find_by_sql("SELECT a.long_name AS origin_name, b.long_name AS destination_name FROM itineraries JOIN users ON(itineraries.user_id = users.id) JOIN tickets ON(tickets.itinerary_id = itineraries.id) JOIN flights ON(flights.id = tickets.flight_id) JOIN airports a ON(a.id = flights.origin_id) JOIN airports b ON(b.id = flights.destination_id) WHERE users.first_name = 'Alec' AND users.last_name = 'Hermann'")
     


# Aggregation

1. Find the top 5 most expensive flights that end in California.
   Flight.find_by_sql("SELECT flights.id, flights.price FROM flights JOIN airports ON(flights.destination_id = airports.id) JOIN states ON(airports.state_id = states.id) WHERE states.name = 'California' ORDER BY flights.price DESC LIMIT 5")

2. Find the shortest flight that username "ryann_anderson" took.
   Flight.find_by_sql("SELECT flights.distance, users.username, flights.id AS flight_number FROM flights JOIN tickets ON(flights.id = tickets.flight_id) JOIN itineraries ON(tickets.itinerary_id = itineraries.id) JOIN users ON(itineraries.user_id = users.id) WHERE users.username = 'paige' ORDER BY flights.distance LIMIT 1")

3. Find the average flight distance for flights entering or leaving each city in Florida
   State.find_by_sql("SELECT AVG(flights.distance) FROM flights JOIN airports a ON(flights.origin_id = a.id) JOIN airports b ON(flights.destination_id = b.id) JOIN states s1 ON(a.state_id = s1.id) JOIN states s2 ON(b.state_id = s2.id) WHERE s1.name = 'Florida' OR s2.name = 'Florida'")

4. Find the 3 users who spent the most money on flights in 2013
   User.find_by_sql("SELECT users.username,flights.departure_time, MAX(flights.price) FROM itineraries JOIN users ON(users.id = itineraries.user_id) JOIN tickets ON(tickets.itinerary_id = itineraries.id) JOIN flights ON(tickets.flight_id = flights.id) WHERE flights.departure_time BETWEEN '2013-01-01' AND '2013-12-31' GROUP BY users.username, flights.departure_time ORDER BY MAX(flights.price) DESC LIMIT 3")

5. Count all flights to or from the city of Lake Mattie that did not land in Florida
   Flight.find_by_sql("SELECT COUNT(*) FROM flights JOIN airports a ON(a.id = flights.origin_id) JOIN airports b ON (b.id = flights.destination_id) WHERE (a.city_id = (SELECT cities.id FROM cities WHERE cities.name = 'Lake Mattie') OR b.city_id = (SELECT cities.id FROM cities WHERE cities.name = 'Lake Mattie')) AND (a.state_id != 9 OR b.state_id != 9)")

6. Return the range of lengths of flights in the system(the maximum, and the minimum).
   Flight.find_by_sql("SELECT MIN(distance), MAX(distance) FROM flights")
   

# Advanced

1. Find the most popular travel destination for users who live in Kansas.
   Airport.find_by_sql("SELECT airports.code, COUNT(*) FROM states JOIN users ON(states.id = users.state_id) JOIN itineraries ON(itineraries.user_id = users.id) JOIN tickets ON(itineraries.id = tickets.itinerary_id) JOIN flights ON(flights.id = tickets.flight_id) JOIN airports ON(airports.id = flights.destination_id) WHERE states.name = 'Kansas' GROUP BY airports.id ORDER BY COUNT(*) DESC LIMIT 1")

2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM  that airport and a later flight TO that airport.
    Flight.find_by_sql("SELECT COUNT(DISTINCT a.origin_id) FROM flights a JOIN flights b ON(a.origin_id = b.destination_id) WHERE a.departure_time < b.arrival_time")


3. Find the cheapest flight that was taken by a user who only had one itinerary.
   User.find_by_sql("SELECT users.id, users.first_name, users.last_name, MIN(flights.price) FROM itineraries JOIN users ON(itineraries.user_id = users.id) JOIN tickets ON(tickets.itinerary_id = itineraries.id) JOIN flights ON(tickets.flight_id = flights.id) GROUP BY users.id, users.first_name, users.last_name HAVING COUNT(*) = 1 ORDER BY MIN(flights.price) ASC LIMIT 1")

4. Find the average cost of a flight itinerary for users in each state in 2012.
   Flight.find_by_sql("SELECT states.name, AVG(flights.price) FROM states JOIN users ON(states.id = users.state_id) JOIN itineraries ON(itineraries.user_id = users.id) JOIN tickets ON(tickets.itinerary_id = itineraries.id) JOIN flights ON(flights.id = tickets.flight_id) GROUP BY states.name ORDER BY states.name")   









