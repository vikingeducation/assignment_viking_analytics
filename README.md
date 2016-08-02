[Leo Ahnn](github.com/leosaysger) and [Johnny Steenbergen](github.com/jsteenb2)
# assignmnent_viking_analytics


1.

```sql
User.find_by_sql "SELECT first_name FROM users JOIN states ON states.id = state_id WHERE states.name = 'California';"
```

2.

```sql
User.find_by_sql "SELECT long_name FROM airports JOIN states ON states.id = state_id WHERE states.name = 'Minnesota';
```

3.

```sql
Itinerary.find_by_sql "SELECT payment_method FROM itineraries JOIN users ON user_id=users.id WHERE users.email = 'heidenreich_kara@kunde.net';"
```

4.

Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.

```sql

```

5.

Find a list of all Airport names and codes which connect to the airport coded LYT.

```sql

```

6.

Get a list of all airports visited by user Dannie D'Amore after January 1, 2012. (Hint, see if you can get a list of all ticket IDs first). Note: Careful how you escape the quote in "D'Amore"... escaping in SQL is different from Ruby.

```sql

```
