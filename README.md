# assignmnent_viking_analytics


User.find_by_sql"SELECT username FROM users"

Airport.find_by_sql"select * from airports where state_id = 23"

SELECT users.email, itineraries.payment_method
FROM users JOIN itineraries ON users.id=itineraries.user_id
WHERE users.email='heidenreich_kara@kunde.net'

select flights.price, airports.long_name
from flights join airports on
flights.origin_id = airports.city_id
where
airports.long_name = 'Kochfurt Probably International Airport'

select airports.long_name, airports.code
from airports
where airports.code = 'LYT'

SELECT CONCAT(users.last_name, ', ', users.first_name),
origin_airport.long_name AS origin,
dest_airport.long_name AS destination,
flights.arrival_time
FROM
tickets JOIN itineraries ON tickets.itinerary_id=itineraries.id
JOIN users ON itineraries.user_id = users.id
JOIN flights ON tickets.flight_id=flights.id
join airports origin_airport ON flights.origin_id=origin_airport.id
join airports dest_airport ON flights.destination_id=dest_airport.id
WHERE
users.first_name= 'Dannie'
and
users.last_name LIKE '%Amore'

--------------------------------------------------------------------------------------

select flights.price, airports.long_name
from flights join airports on flights.destination_id = airports.city_id
join states on airports.state_id = states.id

select flights.price, users.username
from
users join itineraries on users.id = itineraries.user_id
join tickets on itineraries.id = tickets.itinerary_id
join flights on tickets.flight_id = flights.id
where users.username = 'ryann_anderson'
order by flights.price

select avg(flights.distance) as avgtoflorida
from
flights join airports on flights.destination_id = airports.city_id
join states on airports.state_id = states.id
where states.name = 'Florida'

select sum(flights.price) as priceSUM
from
flights join tickets on flights.id = tickets.flight_id
join itineraries on tickets.itinerary_id = itineraries.id
join users on itineraries.user_id = users.id
group by users.username
order by sum(flights.price)
limit 3

select *
from flights left join airports on flights.destination_id = airports.id or flights.origin_id = airports.id
join cities on airports.city_id = cities.id
join states on airports.state_id = states.id
where cities.name = 'Lake Vivienne'
and states.name!='Florida'


#6 don't what it means.

select count(cities.name) as frequency, cities.name as city_name from
(
select users.id as user_id, * from users
join states on users.state_id = states.id
where states.name = 'Kansas'
) as kansas_user
join itineraries on itineraries.user_id = kansas_user.user_id
join tickets on tickets.itinerary_id = itineraries.id
join flights on flights.id = tickets.flight_id
join airports on airports.id = flights.destination_id
join cities on cities.id = airports.city_id
group by cities.name
order by count(cities.name)
desc


select flights.id, flights.destination_id, flights.origin_id, flights.airline_id from
(
select flights.origin_id as destination, flights.destination_id as origin
from flights
) as rev_place
join flights on rev_place.destination = flights.destination_id and rev_place.origin = flights.origin_id
order by flights.origin_id, flights.destination_id, flights.id


select mono.mono_id, flights.price from
(
select sub.user_id as mono_id from
(
select user_id as user_id, count(user_id) as frquency from
itineraries
group by user_id
) as sub
where sub.frquency = 1
) as mono
join itineraries on mono.mono_id = itineraries.user_id
join tickets on tickets.itinerary_id = itineraries.id
join flights on flights.id = tickets.flight_id
limit 1


SELECT avg(sum_all), state_name from
(
select sum(flights.price) as sum_all, users.username, states.name as state_name from
users
join itineraries on users.id = itineraries.user_id
join tickets on itineraries.id = tickets.itinerary_id
join flights on flights.id = tickets.flight_id
join states on states.id = users.state_id
group by users.username
,states.name
order by states.name
) as test
group by test.state_name