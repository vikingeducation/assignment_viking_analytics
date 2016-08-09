# assignmnent_viking_analytics

Luke/schoetlr



Warmups


1)
select username from users join states on state_id=states.id where name='California';

2)
Airport.find_by_sql ["select * from airports join states on state_id=states.id where name='Minnesota';"]


3)

Itinerary.find_by_sql ["select itineraries.payment_method from itineraries join users on user_id=users.id where users.email='heidenreich_kara@kunde.net';"]

4)
Flight.find_by_sql ["select price from flights join airports on origin_id=airports.id where long_name='Kochfurt Probably International Airport';"]


5)

Flight.find_by_sql ["select x.code, y.code from flights join airports x on flights.destination_id = x.id join airports y on flights.origin_id = y.id where x.code = 'LYT' or y.code = 'LYT'"]


6)

User.find_by_sql ["select x.code, y.code from users join itineraries on users.id = itineraries.user_id join tickets on itineraries.id = tickets.itinerary_id join flights on tickets.flight_id = flights.id join airports x on flights.origin_id = x.id join airports y on flights.destination_id = y.id where users.first_name = 'Dannie' and users.last_name = 'D''Amore'"]


Intermediate

1)
State.find_by_sql ["select x.price, y.price from states join airports on states.id = airports.state_id join flights x on airports.id = x.origin_id join flights y on airports.id = y.destination_id where states.name = 'California' order by x.price desc, y.price desc limit 5"]

2)
Flight.find_by_sql ["select (arrival_time - departure_time) as length from flights where id in (select tickets.flight_id from users join itineraries on users.id = itineraries.user_id join tickets on itineraries.id = tickets.itinerary_id where users.username = 'ryann_anderson') order by (arrival_time - departure_time) asc limit 1"]


3)
Flight.find_by_sql ["select avg(distance) from flights where origin_id in (select airports.id from states join airports on states.id = airports.state_id where states.name = 'Maine') or destination_id in (select airports.id from states join airports on states.id = airports.state_id where states.name = 'Maine')"]


4)
User.find_by_sql ["select users.username, sum(flights.price) from users join itineraries on users.id = itineraries.user_id join tickets on itineraries.id = tickets.itinerary_id join flights on tickets.flight_id = flights.id group by users.username order by sum(flights.price) desc"]
 


5)
Flight.find_by_sql ["select count(id) from flights where (origin_id = (select airports.id from cities join airports on cities.id = airports.city_id where cities.name = 'Lake Vivienne') and destination_id != (select airports.id from states join airports on states.id = airports.state_id where states.name = 'Florida')) or (destination_id = (select airports.id from cities join airports on cities.id = airports.city_id where cities.name = 'Lake Vivienne') and origin_id != (select airports.id from states join airports on states.id = airports.state_id where states.name = 'Florida'))"]


6)
Flight.find_by_sql ["select max(arrival_time-departure_time), min(arrival_time-departure_time) from flights"]



Advanced


1)
State.find_by_sql ["select name, count(name) from states where id in (select state_id from airports where id in (select destination_id from flights where origin_id in (select id from airports where state_id = (select id from states where name = 'Kansas')))) group by name"]


2)
Flight.find_by_sql ["select x.id as flight, x.origin_id as from, y.origin_id as to, y.id as return_flight, y.destination_id as back_to from flights x join flights y on x.destination_id = y.origin_id where x.origin_id = y.destination_id"]


3)
User.find_by_sql ["select users.username, flights.price from users join itineraries on users.id = itineraries.user_id join tickets on itineraries.id = tickets.itinerary_id join flights on tickets.flight_id = flights.id where users.id in (select user_id from itineraries group by user_id having count(id) = 1) order by flights.price asc limit 1"]


4
State.find_by_sql ["select states.name as state, avg(flights.price) as avg_price from states join users on states.id = users.state_id join itineraries on users.id = itineraries.user_id join tickets on itineraries.id = tickets.itinerary_id join flights on tickets.flight_id = flights.id group by states.name order by states.name"]