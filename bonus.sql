-- Flight.find_by_sql("


SELECT * FROM (

  SELECT s.name AS orig, s2.name as dest, f.price, 
       f.distance, f.departure_time
    FROM flights f
    -- flights must be FROM one of the states
    JOIN airports a ON f.origin_id = a.id
    JOIN states s ON a.state_id = s.id
    -- flights must be TO one of the states
    JOIN flights f2 on f2.id = f.id
    JOIN airports a2 ON f2.destination_id = a2.id
    JOIN states s2 ON a2.state_id = s2.id
WHERE s.name IN ('Pennsylvania', 'Arkansas', 'Oregon') -- origin
AND s2.name IN ('Pennsylvania', 'Arkansas', 'Oregon') -- destination
AND f.distance <= 400
AND s.name != s2.name -- going to the same state doesn't help us


-- missing some direct flights during my timeframe, so I opened it up
-- AND f.departure_time BETWEEN '2013-05-06' AND '2013-06-10'
GROUP BY s.name, s2.name, f.price, f.distance, f.departure_time

) as nested

GROUP BY nested.orig, nested.dest, nested.price, nested.distance, nested.departure_time
HAVING count(nested.dest = 'Pennsylvania') = 1
  OR count(nested.orig = 'Pennsylvania') = 1 
  AND count(nested.dest = 'Arkansas') = 1 
  OR count(nested.orig = 'Arkansas') = 1 
  AND count(nested.dest = 'Oregon') = 1 
  OR count(nested.orig = 'Oregon') = 1 

")
