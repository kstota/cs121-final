EXPLAIN SELECT type_1, type_2, COUNT(*) AS num_pokemon
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND detect_weak(pkmn_name, 'ground')
GROUP BY type_1, type_2;