# assignmnent_viking_analytics
Sean Kelly

Warmup
1.
 "SELECT username, first_name, last_name FROM users where state_id = 5"
 2.
Airport.find_by_sql "SELECT cities.name, long_name FROM airports JOIN states ON state_id = states.id JOIN cities ON city_id = cities.id WHERE states.name = 'Minnesota'"

3.
Itinerary.find_by_sql "SELECT payment_method, users.email FROM itineraries JOIN users ON user_id = users.id WHERE users.email = 'heidenreich_kara@kunde.net'"

4. *****************
Flight.find_by_sql "SELECT airports.long_name, destination_id, price FROM flights JOIN airports on origin_id = airports.id WHERE airport.long_name = 'Kochfurt Probably International Airport'"

5.***
Flight.find_by_sql "SELECT origin.code as origin, destination.code as destination FROM flights a JOIN flights b ON
  (a.id=b.id)
  JOIN airports origin ON (a.origin_id=origin.id)
  JOIN airports destination ON (b.destination_id=destination.id) WHERE origin.code = 'DCW' or destination.code = 'DCW'"

6.
Ticket.find_by_sql "SELECT airports.long_name FROM tickets JOIN flights ON tickets.flight_id = flights.id JOIN itineraries ON itineraries.id = tickets.itinerary_id JOIN users ON itineraries.user_id = users.id JOIN airports ON airports.id = destination_id OR airports.id = origin_id WHERE first_name = "Dannie" AND last_name "D'Amore""

QUERIES 2: ADDING IN AGGREGATION
1.
Flight.find_by_sql "SELECT origin_id, destination_id, price FROM flights ORDER BY price desc LIMIT 5 WHERE origin_id = 'Florida'"
%%%% need to self join

*2.Find the shortest flight that username "ryann_anderson" took.*
Flight.find_by_sql "SELECT min(distance) FROM flights JOIN tickets ON flights.id = tickets.flight_id JOIN itineraries ON itineraries.id = tickets.itinerary_id JOIN users ON users.id = itineraries.user_id WHERE users.username = 'bobby'"

*3.Find the average flight distance for flights entering or leaving each city in Florida*
Flight.find_by_sql "SELECT avg(a.distance), origin_city.name as orcity, destination_city.name as destcity FROM flights a JOIN flights b on a.id = b.id JOIN airports as origin ON origin.id = a.origin_id JOIN airports as destination on destination.id = b.destination_id JOIN cities as origin_city ON origin_city.id = origin.city_id JOIN cities as destination_city on destination_city.id = destination.city_id JOIN states s1 ON origin.state_id = s1.id JOIN states s2 ON destination.state_id = s2.id WHERE s1.name = 'South Dakota' OR s2.name = 'South Dakota' GROUP BY orcity, destcity"
*is this right?*

*4.Find the 3 users who spent the most money on flights in 2013*
Ticket.find_by_sql "SELECT username, sum(price) from tickets JOIN itineraries ON itinerary_id = itineraries.id JOIN flights ON flights.id = tickets.flight_id JOIN users ON users.id = itineraries.user_id GROUP BY users.username ORDER BY sum(price) DESC LIMIT 3"

*5.Count all flights to or from the city of Lake Vivienne that did not land in Florida*
Flight.find_by_sql "SELECT origin_city.name as orcity, s1.name as orstate, destination_city.name as destcity, s2.name as deststate FROM flights a JOIN flights b on a.id = b.id JOIN airports as origin ON origin.id = a.origin_id JOIN airports as destination on destination.id = b.destination_id JOIN cities as origin_city ON origin_city.id = origin.city_id JOIN cities as destination_city on destination_city.id = destination.city_id JOIN states s1 ON origin.state_id = s1.id JOIN states s2 ON destination.state_id = s2.id WHERE (origin_city.name = 'Lake Vivienne' OR destination_city.name = 'Lake Vivienne') AND s2.name <> 'Florida'"


*6.Return the range of lengths of flights in the system(the maximum, and the minimum).*
Flight.find_by_sql "SELECT max(arrival_time - departure_time), min(arrival_time - departure_time) from flights"

QUERIES 3: ADVANCED
*1.Find the most popular travel destination for users who live in Kansas.*
Flight.find_by_sql "SELECT destination_id = FROM flights JOIN tickets on flights.id = tickets.flight_id JOIN itineraries ON itineraries.id = tickets.itinerary_id JOIN users on users.id = itineraries.user_id JOIN states ON users.state_id = states.id JOIN airports on destination.id = WHERE states.name = 'South Dakota'"

2.How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
Flight.find_by_sql "SELECT "


*3.Find the cheapest flight that was taken by a user who only had one itinerary.*
?

*4.Find the average cost of a flight itinerary for users in each state in 2012.*
Flight.find_by_sql "SELECT avg(price), states.name from flights JOIN tickets ON flights.id = tickets.flight_id JOIN itineraries ON itineraries.id = tickets.itinerary_id JOIN users ON itineraries.user_id = users.id JOIN states ON states.id = users.state_id GROUP BY states.name"
