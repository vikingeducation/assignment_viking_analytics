# Warmups

-- Get a list of all users in California
select username from users join states on users.state_id = states.id where states.name = 'California';

 -- Get a list of all airports in Minnesota
select airports.long_name from airports join states on airports.state_id = states.id where states.name = 'Minnesota';

-- Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
select payment_method from itineraries join users on itineraries.user_id = users.id where email = 'heidenreich_kara@kunde.net';

-- Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
select price from flights join airports on flights.origin_id = airports.id where long_name = 'Kochfurt Probably International Airport';

-- Find a list of all Airport names and codes which connect to the airport coded LYT.
select airports.long_name, airports.code from airports 
join flights ON destination_id = airports.id
join airports ON origin_id = airports.id
WHERE destinations.code = 'LYZ';

 -- Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.


SELECT distinct a1.long_name, a2.long_name from airports AS a1 
join flights on a1.id = flights.origin_id 
join airports a2 on a2.id = flights.destination_id
join tickets on tickets.flight_id = flights.id
join itineraries it on it.id = tickets.itinerary_id
join users on users.id = it.user_id
where users.username = 'diego_spencer'
and flights.departure_time > '2012-01-01'

---------------------------


# Adding in Aggregation
 -- Find the top 5 most expensive flights that end in California.
SELECT price FROM flights
JOIN airports on airports.id = flights.destination_id 
JOIN states on states.id = airports.state_id
WHERE states.name = 'California'
ORDER BY price desc;

 -- Find the shortest flight that username "ryann_anderson" took.
SELECT MIN(distance) FROM flights
JOIN tickets ON tickets.flight_id = flights.id
JOIN itineraries AS it ON it.id = tickets.itinerary_id
JOIN users ON users.id = it.user_id 
WHERE username = 'diego_spencer';

 -- Find the average flight distance for flights entering or leaving each city in Florida
SELECT AVG(distance) FROM flights
JOIN airports on airports.id in (flights.destination_id, flights.origin_id)
JOIN states on states.id = airports.state_id
WHERE states.name = 'Florida';


 -- Find the 3 users who spent the most money on flights in 2013
SELECT username, sum(price) FROM users
JOIN itineraries it on it.user_id = users.id
JOIN tickets on tickets.itinerary_id = it.id
JOIN flights on flights.id = tickets.flight_id
WHERE SUBSTRING(CAST(flights.departure_time AS VARCHAR), 1, 4) = '2013'
GROUP by username
ORDER by SUM(price) desc
LIMIT 3;

 -- Count all flights to or from the city of Lake Vivienne that did not land in Florida
SELECT COUNT(*) FROM flights
JOIN airports on airports.id in (flights.destination_id, flights.origin_id)
JOIN cities on cities.id = airports.city_id
WHERE cities.name = 'Lake Antonina'
and flights.destination_id not in (
  select destination_id from flights
  JOIN airports on airports.id = flights.destination_id
  JOIN cities on cities.id = airports.city_id
  WHERE cities.name = 'Florida');

 -- Return the range of lengths of flights in the system(the maximum, and the minimum).
 SELECT MIN(distance), MAX(distance) FROM flights;


---------------------------

# Advanced
 -- Find the most popular travel destination for users who live in Kansas.
SELECT COUNT(*), flights.id from cities
JOIN airports on airports.city_id = cities.id
JOIN flights on flights.destination_id = airports.id
JOIN tickets on tickets.flight_id = flights.id
JOIN itineraries AS it on it.id = tickets.itinerary_id
JOIN users on users.id = it.user_id
JOIN states on states.id = users.state_id
WHERE states.name = 'Kansas'
ORDER BY 1 desc
GROUP BY flights.id;

 -- How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
SELECT f1.origin_id, f1.destination_id, f2.origin_id, f2.destination_id from flights f1
JOIN flights f2 on f1.origin_id = f2.destination_id
WHERE f1.destination_id = f2.origin_id and
f1.departure_time < f2.arrival_time;


 -- Find the cheapest flight that was taken by a user who only had one itinerary.
SELECT COUNT(*), it.user_id, MIN(price) from itineraries it
join tickets on tickets.itinerary_id = it.user_id
join flights on flights.id = tickets.itinerary_id
GROUP BY user_id
HAVING COUNT(*) = 1
ORDER BY 3 ASC
LIMIT 1;

 -- Find the average cost of a flight itinerary for users in each state in 2012.
SELECT AVG(price), states.name FROM flights
JOIN tickets on tickets.flight_id = flights.id
JOIN itineraries it on it.id = tickets.itinerary_id
JOIN users on users.id = it.user_id
JOIN states on states.id = users.state_id
WHERE SUBSTRING(CAST(flights.departure_time AS VARCHAR), 1, 4) = '2012'
GROUP BY states.name;


 -- Bonus: You're a tourist. It's May 6, 2013. Book the ch eapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.
 --Attempt but correction probably required
 SELECT f1.origin_id, f1.destination_id, f2.origin_id, f2.destination_id, MIN(f1.price), MIN(f2.price) from flights f1
 JOIN airports a1 on a1.id = f1.origin_id
 JOIN states s1 on s1.id = a1.state_id
 JOIN airports a2 on a2.id = f1.destination_id
 JOIN states s2 on s2.id = a2.state_id
 JOIN flights f2 on f1.destination_id = f2.origin_id
 JOIN airports a3 on a3.id = f2.origin_id
 JOIN states s3 on s3.id = a3.state_id
 WHERE f1.distance < 400 
 AND f1.departure_time > '2013-05-06'
 AND f2.departure_time > f1.arrival_time
 AND s1.name = 'Oregon'
 AND s2.name = 'Pennsylvania'
 AND s3.name = 'Arkansas'
 AND f2.distance < 400
 GROUP BY f1.origin_id, f1.destination_id, f2.origin_id, f2.destination_id;
