SELECT user_id, SUM(num_pokemon) AS pokemon_total
FROM box_owner NATURAL JOIN boxes 
GROUP BY user_id;