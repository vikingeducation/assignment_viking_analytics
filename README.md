# assignmnent_viking_analytics


Deepa + Julia

Get a list of all users in California
```
User.find_by_sql("
SELECT u.* from users u 
JOIN states s ON u.state_id = s.id 
WHERE s.name = 'California'
")
```
Get a list of all airports in Minnesota
```
Airport.find_by_sql("
SELECT a.* from airports a 
JOIN states s ON a.state_id = s.id 
WHERE s.name = 'Minnesota'
")
```
Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net" (with multiplier = 5, that user doesn't exist, so we used another one)
```
Itinerary.find_by_sql("
SELECT i.payment_method FROM itineraries i
JOIN users u on u.id = i.user_id
WHERE u.email = 'heathcote.davin@rutherfordcummerata.info'
")
```
User.find_by_sql("SELECT * from users where email like 'heidenreich%'")

Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
```
Flight.find_by_sql("
SELECT f.price FROM flights f 
JOIN airports a ON a.id = f.origin_id
WHERE a.long_name = 'Edisonmouth Probably International Airport'
")
```
Find a list of all Airport names and codes which connect to the airport coded LYT.

-- airport -- flight -- airport
```
Airport.find_by_sql("
SELECT astart.long_name, astart.code FROM airports astart
JOIN flights f on f.origin_id = astart.id
JOIN airports aconnect ON aconnect.id = f.destination_id
WHERE aconnect.code = 'SQU'
")
```

Airport.find_by_sql("
SELECT a.long_name, a.code FROM airports a
WHERE a.code = 'SQU'
")


Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby. (can't find special character, but it would be 'D\'\Amore' or 'D'''Amore')
```
Ticket.find_by_sql("
SELECT t.id from tickets t 
JOIN itineraries i ON i.id = t.itinerary_id
JOIN users u ON u.id = i.user_id
WHERE u.first_name = 'Dannie'
")

```