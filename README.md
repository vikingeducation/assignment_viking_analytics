# assignmnent_viking_analytics
Ann Allan

-- 1. Some question that asks you to query the database
SELECT * FROM flights;

Warmups

1. Get a list of all users in California
  select users.first_name, users.last_name
  from users join states on users.state_id = states.id
  where states.name = 'California';

2. Get a list of all airports in Kadeton
  select airports.long_name
  from airports join cities on airports.city_id = cities.id
  where cities.name = 'Kadeton';

3. Get a list of all payment methods used on itineraries by the user with email address 'senger.krystel@marvin.io'
select itineraries.payment_method
from itineraries join users on itineraries.user_id = users.id
where email = 'senger.krystel@marvin.io';


4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
select flights.price
from flights join airports on flights.origin_id = airports.id
where airports.long_name = 'Kochfurt Probably International Airport';

5. Find a list of all Airport names and codes which connect to the airport coded LYT.
select airports.long_name, airports.code
from airports join flights on airports.id = flights.origin_id
where flights.destination_id = (select airports.id
  from airports
  where code = 'LYT');

6. Get a list of all airports visited by user Krystel Senger after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first).
select airports.long_name
from ((((airports join flights on airports.id = flights.origin_id) join tickets on flights.id = tickets.flight_id) join itineraries on tickets.itinerary_id = itineraries.id) join users on itineraries.user_id =users.id)
where user.first_name = 'Krystel' AND user.last_name = 'Senger' AND created_at > '2012-01-01';

Aggregate
1. Find the top 5 most expensive flights that end in California.
select id
from flights join airports on flights.destination_id = airports.id join states on airports.state_id = states.id
where states.name = California
order by flights.price DESC
limit 5;


2. Find the shortest flight that username 'zora_johnson' took.
select flights.id
from flights join tickets on flights.id = tickets.flight_id join itineraries on tickets.itinerary_id = itineraries.id join users on itineraries.user_id =users.id
 where users.username = 'zora_johnson'
 order by flights.distance
 limit 1;

3. Find the average flight distance for every city in California
select avg(flight.distance)
from flights join airports on flights.destination_id = airports.id join states on airports.state_id = states.id
where states.name = 'California'
group by states.name;

4. Find the 3 users who spent the most money on flights in 2013
select users.username
from users join itineraries on users.id = itineraries.user_id join tickets on itineraries.id = tickets.itinerary_id join flights on flights.id = tickets.flight_id
where yr = 2013
group by flights.price
limit 3;

5. Count all flights to OR from the city of Smithshire that did not land in Delaware
select count(flights)
from flights join airports on flights.origin_id = airports.id, flights.destination_id = airports.id
where flights.destination_id = (select airports.id
from airports join states on airports.state_id = states.id
where states.name = 'Delaware') AND
(flights.destination_id = (select airports.id
  from airports join cities on airports.city_id = cities.id
  where cities.name = 'Smithshire') OR
  flights.origin_id = (select airports.id
  from airports join cities on airports.city_id = cities.id
  where cities.name = 'Smithshire'));


6. Return the range of lengths of flights in the system(the maximum, and the minimum).
select max(distance), min(distance)
from flights


Advanced
1. Find the most popular travel destination for users who live in California.
select cities.name
from cities join airports on cities.id = airports.city_id join flights on airports.id = flights.destination_id join tickets on flights.id = tickets.flight_id join itineraries on tickets.itinerary_id = itineraries.id join users on itineraries.user_id = users.id
where users.state_id = (select states.id
from states
where states.name = 'California');

2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
select airports.long_name
from airports join flights on airports.id = flights.destination_id, airports.id = flights.origin_id
where flights.arrival_time < flights.departure_time;


3. Find the cheapest flight that was taken by a user who only had one itinerary.
select flights.id
from flights join airports on airports.id = flights.destination_id join tickets on flights.id = tickets.flight_id join itineraries on tickets.itinerary_id = itineraries.id
where flights.price < all AND itineraries.user_id = 1;

4. Find the average cost of a flight itinerary for users in each state in 2012.
select avg(flights.price), state.name
from flights join airports on airports.id = flights.destination_id join state on airports.state_id = states.id
where created_at like '2012-%';


Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.
