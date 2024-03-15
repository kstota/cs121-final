-- Gets number of Pokemon weak to a particular type for a user. 
SELECT type_1, type_2, COUNT(*) AS num_pokemon
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND detect_weak(pkmn_name, 'ground')
GROUP BY type_1, type_2;

-- Gets all Pokemon of a type for a given user. Returns name, nickname, box
-- number, and pokedex number. 
SELECT pkmn_name, pkmn_nickname, (MOD(box_id - 1, 16) + 1) as box_num, 
    pkmn_id, pokedex_number
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (type_1 = 'grass' OR type_2 = 'grass')
ORDER BY pokedex_number;

-- Gets all Pokemon of a given Pokedex number owned by a user. Returns pokedex 
-- number, name, nickname, and box number. 
SELECT pokedex_number, pkmn_name, pkmn_id, pkmn_nickname, 
    (MOD(box_id - 1, 16) + 1) AS box_num
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (pokedex_number = 1)
ORDER BY pkmn_nickname;

-- Gets all Pokemon of a given name owned by a user. Returns name, pokedex
-- number, nickname, and box number. 
SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname, 
    (MOD(box_id - 1, 16) + 1) AS box_num
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex
WHERE user_id = 'ashketch' AND (pkmn_name = 'bulbasaur')
ORDER BY pkmn_nickname;

-- Gets all Pokemon owned by the user in specified box. Returns Pokemon name 
-- and nickname.
SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname hp, attack, 
special_attack, defense, special_defense, speed, lvl, is_hacked 
FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected 
    NATURAL JOIN has_species NATURAL JOIN pokedex 
    NATURAL JOIN hack_checks
WHERE user_id = 'ashketch' AND (MOD(box_id - 1, 16) + 1) = 3;

-- Admin query: gets total number of Pokemon owned by each user in the database.
SELECT user_id, SUM(num_pokemon) AS pokemon_total
FROM box_owner NATURAL JOIN boxes 
GROUP BY user_id;