

1.
SELECT name, continent, population FROM world

2.
SELECT name FROM world
WHERE population>200000000

3.
SELECT name, gdp/population
FROM world
WHERE population >= 200000000

4.
SELECT name, population/1000000
FROM world
WHERE continent = 'South America'

5.
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy')

6.
SELECT name
FROM world
WHERE name LIKE '%united%'

7.
SELECT name, population, area
FROM world
WHERE (area > 3000000) OR (population > 250000000)

8.
SELECT name, population, area
FROM world
WHERE (area > 3000000 OR population > 250000000)
AND NOT (area >= 3000000 AND population >= 250000000)

9.
SELECT name,
ROUND(population/1000000, 2) as population,
ROUND(gdp/1000000000, 2) as gdp
FROM world
WHERE continent = 'South America'

10.
SELECT name, ROUND(gdp/population, -3) as "per-capita GDP"
FROM world
WHERE gdp >= 1000000000000

11.
SELECT name,
       CASE WHEN continent='Oceania' THEN 'Australasia'
            ELSE continent END AS continent
  FROM world
 WHERE name LIKE 'N%'

 12.
 SELECT name,
 CASE WHEN continent='Europe' OR continent = 'Asia' THEN 'Eurasia'
 WHEN continent='North America' OR continent = 'South America' OR continent = 'Caribbean' THEN 'America'
            ELSE continent END AS continent
FROM world
WHERE name LIKE 'A%' OR name LIKE 'B%'

13.

SELECT name, continent,
  CASE
    WHEN continent = 'Oceania' THEN 'Australasia'
    WHEN continent = 'Eurasia' OR name = 'Turkey' THEN 'Europe/Asia'
    WHEN continent = 'Caribbean' THEN
      CASE
        WHEN name LIKE 'B%' THEN 'North America'
        ELSE 'South America'
      END
    ELSE continent
  END
  FROM world
ORDER BY name

1.
-- Change the query shown so that it displays Nobel prizes for 1950.
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

2.
-- Show who won the 1962 prize for Literature.

SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'

3.
-- Show the year and subject that won 'Albert Einstein' his prize.


SELECT yr, subject
  FROM nobel
  WHERE winner = 'Albert Einstein'


-- 4. Give the name of the 'Peace' winners since the year 2000, including 2000.
SELECT winner
  FROM nobel
  WHERE subject = 'Peace'
  AND yr >= 2000

-- 5. Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT yr, subject, winner
  FROM nobel
  WHERE subject = 'Literature'
  AND yr BETWEEN 1980 AND 1989


-- 6.Show all details of the presidential winners:
-- Theodore Roosevelt
-- Woodrow Wilson
-- Jimmy Carter
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter')

-- 7. Show the winners with first name John
SELECT winner
  FROM nobel
  WHERE winner LIKE 'John%'


-- 8. Show the Physics winners for 1980 together with the Chemistry winners for 1984.
SELECT *
  FROM nobel
  WHERE ( subject = 'Physics' AND yr = 1980 )
  OR ( subject = 'Chemistry' AND yr = 1984 )

--
-- 9.
-- Show the winners for 1980 excluding the Chemistry and Medicine

SELECT *
  FROM nobel
  WHERE yr = 1980
  AND NOT ( subject = 'Chemistry' OR subject = 'Medicine' )


-- 10.
-- Show who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004)
SELECT *
  FROM nobel
  WHERE ( subject = 'Medicine' AND yr < 1910 ) OR ( subject = 'Literature' AND yr >= 2004 )

-- Nobel Quiz
-- Harder Questions
-- 11.
-- -- Find all details of the prize won by PETER GRÜNBERG
SELECT *
  FROM nobel
  WHERE winner LIKE 'Peter Gr%nberg'

-- 12.
-- Find all details of the prize won by EUGENE O'NEILL
SELECT *
  FROM nobel
  WHERE winner LIKE 'Eugene O%Neill'

-- 13.
-- Knights in order
--
-- List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.

SELECT winner, yr, subject
  FROM nobel
  WHERE winner LIKE 'sir%'
  ORDER BY yr DESC, winner


-- 14.
-- The expression subject IN ('Chemistry','Physics') can be used as a value - it will be 0 or 1.
--
-- Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY subject IN ('Chemistry','Physics'), subject, winner


-- UEFA EURO 2012
-- The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime

-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
 SELECT matchid, player FROM goal
   WHERE teamid = 'GER'

  --  From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.

  --  Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.

  --  Show id, stadium, team1, team2 for just game 1012

 SELECT DISTINCT id,stadium,team1,team2
  FROM game JOIN goal
    ON game.id = goal.matchid
  WHERE goal.matchid = 1012

  --  3.
  --  You can combine the two steps into a single query with a JOIN.

   SELECT *
     FROM game JOIN goal ON (id=matchid)
  --  The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the id from goal must match matchid from game. (If we wanted to be more clear/specific we could say
  --  ON (game.id=goal.matchid)

  --  The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.

  --  Modify it to show the player, teamid, stadium and mdate and for every German goal.

  SELECT player,teamid, stadium, mdate
    FROM game JOIN goal ON (id=matchid)
    WHERE teamid = 'GER'

  --  4.
  --  Use the same JOIN as in the previous question.

  --  Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

  SELECT team1, team2, player
    FROM game JOIN goal ON (id=matchid)
    WHERE player LIKE 'Mario%'

  --  5.
  --  The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id

  --  Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10


   SELECT player, teamid, coach, gtime
     FROM goal JOIN eteam ON (teamid=id)
    WHERE gtime <= 10

  --  6.
  --  To JOIN game with eteam you could use either
  --  game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)

  --  Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id

  --  List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

  SELECT mdate, teamname
    FROM game JOIN eteam ON (game.team1=eteam.id)
   WHERE coach = 'Fernando Santos'

  --  7.
  --  List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

  SELECT player
    FROM goal JOIN game ON (goal.matchid=game.id)
  WHERE stadium = 'National Stadium, Warsaw'

  --  More difficult questions
  --  8.
  --  The example query shows all goals scored in the Germany-Greece quarterfinal.
  --  Instead show the name of all players who scored a goal against Germany.

   SELECT DISTINCT player
     FROM game JOIN goal ON matchid = id
     WHERE (team1='GER' OR team2='GER')
      AND goal.teamid != 'GER'

  --  9.
  --  Show teamname and the total number of goals scored.
  --  COUNT and GROUP BY

   SELECT teamname, COUNT(teamid)
     FROM eteam JOIN goal ON id=teamid
     GROUP BY teamid
    ORDER BY teamname


  --  10.
  --  Show the stadium and the number of goals scored in each stadium.
  SELECT stadium, COUNT(stadium)
    FROM game JOIN goal ON id=matchid
    GROUP BY stadium


  --  11.
  --  For every match involving 'POL', show the matchid, date and the number of goals scored.
   SELECT matchid, mdate, COUNT(matchid)
    FROM game JOIN goal ON matchid = id
    WHERE (team1 = 'POL' OR team2 = 'POL')
    GROUP BY matchid

  --  12.
  --  For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

   SELECT matchid, mdate, COUNT(matchid)
    FROM game JOIN goal ON matchid = id
    WHERE goal.teamid = 'GER'
    GROUP BY matchid


  --  13.
  --  List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
  --  mdate	team1	score1	team2	score2
  --  1 July 2012	ESP	4	ITA	0
  --  10 June 2012	ESP	1	ITA	1
  --  10 June 2012	IRL	1	CRO	3
  --  ...
  --  Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your  by mdate, matchid, team1 and team2.


   SELECT mdate,
     team1,
     SUM(CASE WHEN teamid=team1 THEN 1
     ELSE 0 END) AS score1,
     team2,
     SUM(CASE WHEN teamid=team2 THEN 1
     ELSE 0 END) AS score2
     FROM game JOIN goal ON matchid = id
     GROUP BY matchid
