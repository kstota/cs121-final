SELECT base_hp FROM pokedex
WHERE pkmn_name = (SELECT pkmn_name FROM has_species WHERE pkmn_id = 1);