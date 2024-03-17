-- VIEW BOX
-- Gets all Pokemon owned by the user in specified box. Returns Pokemon name, 
-- pokedex number, unique Pokemon ID, Pokemon nickname, stat values, and the
-- is_hacked flag. 
SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname, hp, attack, special_attack, defense, 
    special_defense, speed, lvl, is_hacked 
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected NATURAL JOIN has_species NATURAL JOIN pokedex NATURAL JOIN hack_checks 
WHERE user_id = 'ashketch' AND (MOD(box_id - 1, 16) + 1) = 3;

-- GET NUMBER OF POKEMON IN BOX
-- Used when attempting to add a Pokemon to a box
SELECT num_pokemon FROM boxes NATURAL JOIN box_owner 
WHERE user_id = 'ashketch' AND (MOD(box_id - 1, 16) + 1) = 1;

-- SEARCH BY TYPE
-- Gets all Pokemon of a type for a given user. Returns name, nickname, box
-- number, and pokedex number. 
SELECT pkmn_name, pkmn_nickname, (MOD(box_id - 1, 16) + 1) AS box_num, 
    pokedex_number
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (type_1 = 'grass' OR type_2 = 'grass')
ORDER BY pokedex_number;

-- SEARCH LEVEL RANGE 
-- Selects all Pokemon owned by a particular user within a desired level range.  
SELECT pkmn_id, pkmn_nickname, lvl
FROM collected NATURAL JOIN has_box NATURAL JOIN box_owner 
WHERE user_id = 'ashketch' AND lvl <= 80 AND lvl >= 20
ORDER BY lvl DESC;

-- SEARCH BY DEX
-- Gets all Pokemon of a given Pokedex number owned by a user. Returns pokedex 
-- number, name, nickname, and box number. 
SELECT pokedex_number, pkmn_name, pkmn_nickname, 
    (MOD(box_id - 1, 16) + 1) AS box_num
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND pokedex_number = 1
ORDER BY pkmn_nickname;

-- SEARCH BY POKEMON SPECIES
-- Gets all Pokemon of a given name owned by a user. Returns name, pokedex
-- number, nickname, and box number. This is equivalent to SEARCH BY DEX, so 
-- we choose to only include the former in our UI. 
SELECT pkmn_name, pokedex_number, pkmn_nickname, 
    (MOD(box_id - 1, 16) + 1) AS box_num
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (pkmn_name = 'bulbasaur')
ORDER BY pkmn_nickname;

-- ANALYZE TYPE ADVANTAGES
-- Gets all Pokemon owned by a user that are weak to a specified attack type.
SELECT pkmn_id, (MOD(box_id - 1, 16) + 1) as box_num, pkmn_name,
pkmn_nickname, type_1, type_2
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected
NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND detect_weak(pkmn_name, 'ground')
ORDER BY pkmn_name, pkmn_nickname;

-- COUNT POKEMON (ADMIN-ONLY QUERY)
-- Gets total number of Pokemon owned by each user in the database.
SELECT user_id, SUM(num_pokemon) AS total_count
FROM box_owner NATURAL JOIN boxes 
GROUP BY user_id
ORDER BY total_count DESC;

-- VIEW HACKED POKEMON (ADMIN-ONLY QUERY)
-- Gets all Pokemon stored in the database that have been identified as hacked.
SELECT pkmn_id, pkmn_name, pkmn_nickname, user_id 
FROM collected NATURAL JOIN has_box NATURAL JOIN box_owner 
    NATURAL JOIN hack_checks NATURAL JOIN has_species NATURAL JOIN pokedex 
WHERE is_hacked = 1;

