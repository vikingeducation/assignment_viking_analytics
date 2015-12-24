# assignmnent_viking_analytics

by Sia Karamalegos

## Warmups

**Get a list of all users in California**
```
SELECT u.username
FROM users u JOIN states s ON s.id = u.state_id
WHERE s.name = 'California';
```

**Get a list of all airports in Minnesota**
```
SELECT a.code, a.long_name
FROM airports a JOIN states s ON s.id = a.state_id
WHERE s.name = 'Minnesota';
```

**Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"** (use janae.zulauf@hermiston.biz for my dbase)
```
SELECT DISTINCT i.payment_method
FROM itineraries i JOIN users u ON u.id = i.user_id
WHERE u.email = 'heidenreich_kara@kunde.net';
```

**Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport** (use Edisonmouth instead)
```
SELECT f.price
FROM flights f JOIN airports a ON f.origin_id = a.id
WHERE a.long_name = 'Edisonmouth Probably International Airport';
```

**Find a list of all Airport names and codes which connect to the airport coded LYT.** (Use TDE instead)
```
SELECT DISTINCT a.code, a.long_name
FROM airports a
  JOIN flights of ON of.origin_id = a.id
  JOIN flights df ON df.destination_id = a.id
WHERE of.destination_id = (
    SELECT id FROM airports WHERE code = 'TDE')
  OR df.origin_id = (
    SELECT id FROM airports WHERE code = 'TDE');
```

**Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.**
```
SELECT ad.long_name, ao.long_name
FROM users u
  JOIN itineraries i ON i.user_id = u.id
  JOIN tickets t ON t.itinerary_id = i.id
  JOIN flights f ON f.id = t.flight_id
  JOIN airports ao ON ao.id = f.origin_id
  JOIN airports ad ON ad.id = f.destination_id
WHERE u.first_name = 'Dannie' AND u.last_name = 'D''Amore' AND f.departure_time > '2012-01-01';
```

