# assignmnent_viking_analytics


David Meza

Nick Sarlo


## Warmups

Here are some queries we'd like you to answer using this ActiveRecord database.

1. Get a list of all users in California

    SELECT users.id, users.first_name, users.last_name, states.name 
    FROM users JOIN states ON users.state_id = states.id 
    WHERE states.name = 'California'


Get a list of all airports in Minnesota
Get a list of all payment methods used on itineraries by the user with email address "heidenreich_kara@kunde.net"
Get a list of prices of all flights whose origins are in Kochfurt Probably International Airport.
Find a list of all Airport names and codes which connect to the airport coded LYT.
Get a list of all airports visited by user Dannie D'Amore after January 1, 2015. (Hint, see if you can get a list of all ticket IDs first).
