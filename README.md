# assignmnent_viking_analytics
# Andrea A


# Warmups
### Get a list of all users in California
```select username from users join states on users.state_id = states.id where states.name = 'California'```

### Get a list of all airports in Minnesota
```select airports.long_name from airports join states on airports.state_id = states.id where states.name = 'Minnesota'```

### Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
```select payment_method from itineraries join users on itineraries.user_id = users.id where email = 'heidenreich_kara@kunde.net'```

### Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```select price from flights join airports on flights.origin_id = airports.id where long_name = 'Kochfurt Probably International Airport';```

### Find a list of all Airport names and codes which connect to the airport coded LYT.

<!-- select airports.long_name, airports.code from airports 
join flights ON destination_id = airports.id
join airports ON origin_id = airports.id
WHERE destinations.code = 'ULZ' -->

### Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.

<!-- Work in progress -->
```select * from tickets where user_id in (select user_id from users where user_name = 'diego_spencer');```

---------------------------


# Adding in Aggregation
### Find the top 5 most expensive flights that end in California.




### Find the shortest flight that username "ryann_anderson" took.
### Find the average flight distance for flights entering or leaving each city in Florida
### Find the 3 users who spent the most money on flights in 2013
### Count all flights to or from the city of Lake Vivienne that did not land in Florida
### Return the range of lengths of flights in the system(the maximum, and the minimum).


---------------------------

# Advanced
### Find the most popular travel destination for users who live in Kansas.
### How many flights have round trips possible? In other words, we want the count of all airports where there exists a flight FROM that airport and a later flight TO that airport.
### Find the cheapest flight that was taken by a user who only had one itinerary.
### Find the average cost of a flight itinerary for users in each state in 2012.
### Bonus: You're a tourist. It's May 6, 2013. Book the cheapest set of flights over the next six weeks that connect Oregon, Pennsylvania and Arkansas, but do not take any flights over 400 miles in distance. Note: This can be ~50 lines long but doesn't require any subqueries.
