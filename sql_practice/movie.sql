1.
List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962


2.
Give year of 'Citizen Kane'.
SELECT yr
 FROM movie
 WHERE title = 'Citizen Kane'


3.
List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order s by year.

SELECT id, title, yr
 FROM movie
 WHERE title  LIKE '%Star Trek%'
ORDER BY yr


4.
What are the titles of the films with id 11768, 11955, 21191

SELECT title
 FROM movie
 WHERE id IN (11768, 11955, 21191)

5.
What id number does the actress 'Glenn Close' have?

SELECT id
 FROM actor
 WHERE name = 'Glenn Close'


6.
What is the id of the film 'Casablanca'
SELECT id
 FROM movie
 WHERE title = 'Casablanca'


7.
Obtain the cast list for 'Casablanca'.
what is a cast list?
Use movieid=11768, this is the value that you obtained in the previous question.

SELECT name
 FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON actor.id = casting.actorid
 WHERE movieid = 11768


8.
Obtain the cast list for the film 'Alien'
SELECT name
 FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON actor.id = casting.actorid
 WHERE title = 'Alien'

9.
List the films in which 'Harrison Ford' has appeared
SELECT title
 FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON actor.id = casting.actorid
 WHERE name = 'Harrison Ford'


10.
List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

SELECT title
 FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON actor.id = casting.actorid
 WHERE name = 'Harrison Ford'
AND ord != 1


11.
List the films together with the leading star for all 1962 films.

SELECT title, name AS lead
 FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON actor.id = casting.actorid
 WHERE yr = 1962
AND ord = 1



Harder Questions
12.
Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 WHERE name='John Travolta'
 GROUP BY yr) AS t
)

OR THE BETTER WAY

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title) > 2



13.
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
Did you get "Little Miss Marker twice"?

SELECT DISTINCT title, name AS lead
FROM ( SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Julie Andrews') ) AS ja_table JOIN casting ON casting.movieid=ja_table.movieid
         JOIN actor ON actorid=actor.id JOIN movie ON movie.id=casting.movieid

14.
Obtain a list, in alphabetical order, of actors who have had at least 30 starring roles.

SELECT name
  FROM casting 
    JOIN actor
      ON actorid = actor.id
  WHERE ord = 1
  GROUP BY name
  HAVING COUNT(name) >= 30

15.
List the films released in the year 1978 ordered by the number of actors in the cast.

SELECT title, COUNT(name) AS count
  FROM actor
    JOIN casting
      ON actor.id=actorid
    JOIN movie   
      ON movieid=movie.id
  WHERE yr = 1978
  GROUP BY title
  ORDER BY count DESC


16.
List all the people who have worked with 'Art Garfunkel'.

SELECT DISTINCT name
FROM ( SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Art Garfunkel') ) AS ja_table JOIN casting ON casting.movieid=ja_table.movieid
         JOIN actor ON actorid=actor.id JOIN movie ON movie.id=casting.movieid
WHERE name != 'Art Garfunkel'



