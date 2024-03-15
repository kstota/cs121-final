-- Gets all Pokemon of a type for a given user. Returns name, nickname, box
-- number, and pokedex number. 
SELECT pkmn_name, pkmn_nickname, (MOD(box_id - 1, 16) + 1) as box_num, 
    pkmn_id, pokedex_number
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (type_1 = 'grass' OR type_2 = 'grass')
ORDER BY pokedex_number;

-- Gets all Pokemon owned by the user in specified box. Returns Pokemon name 
-- and nickname.
SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (MOD(box_id - 1, 16) + 1) = 3;

-- Admin query: gets total number of Pokemon owned by each user in the database.
SELECT user_id, SUM(num_pokemon) AS pokemon_total
FROM box_owner NATURAL JOIN boxes 
GROUP BY user_id;