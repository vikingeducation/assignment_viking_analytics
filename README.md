# assignmnent_viking_analytics

Anne Richardson

## Queries 1: Warmups

When working in `rails console`, wrap all queries in `ModelName.find_by_sql "your-query-here"`. Otherwise, if working directly in the postgres console, run all queries as shown below.

Note: Many of the supplied query names were not present in my seeded data. For this reason, I used a modified data to yield some result from by database.

1. Get a list of all users in California
```
SELECT *
FROM users u JOIN states s ON s.id = u.state_id
WHERE s.name = 'Nebraska';
```
2. Get a list of all airports in Minnesota
```
SELECT *
FROM airports a
  JOIN states s ON a.state_id = s.id
WHERE s.name LIKE 'Minnesota';
```
3. Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```
SELECT DISTINCT payment_method
FROM users u
  JOIN itineraries i ON u.id = i.user_id
WHERE u.email = 'lueilwitz.caesar@leffler.name';
```
4. Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
SELECT f.price
FROM flights f
  JOIN airports a ON f.origin_id = a.id
WHERE a.long_name LIKE 'Hiramfort Probably International Airport';
```
5. Find a list of all Airport names and codes which connect to the airport coded LYT.
```
```
6. Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.
```
```

## Queries 2: Adding in Aggregation

1. Find the top 5 most expensive flights that end in California.
2. Find the shortest flight that username "ryann_anderson" took.
3. Find the average flight distance for flights entering or leaving each city in Florida
4. Find the 3 users who spent the most money on flights in 2013
5. Count all flights to or from the city of Lake Vivienne that did not land in Florida
6. Return the range of lengths of flights in the system(the maximum, and the minimum).

## Queries 3: Advanced

1. Find the most popular travel destination for users who live in Kansas.
2. How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
3. Find the cheapest flight that was taken by a user who only had one itinerary.
4. Find the average cost of a flight itinerary for users in each state in 2012.
5. Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.
