-- Inserting users
CALL sp_add_client('ashketch', 'gottacatch');
CALL sp_add_client('mistywat', 'cerulean');
CALL sp_add_admin('brockrock', 'single4ever');

-- Inserting collected Pokémon 
INSERT INTO collected (pkmn_nickname, hp, attack, special_attack, defense, special_defense, speed, lvl) VALUES
('Pika', 21, 11, 11, 11, 13, 15, 5),
('Bulby', 45, 49, 65, 49, 65, 45, 5),
('Charmy', 39, 52, 60, 43, 50, 65, 5),
('Squirty', 44, 48, 50, 65, 64, 43, 5),
('Veevee', 55, 55, 45, 50, 65, 55, 5),
('Jolty', 40, 60, 50, 40, 50, 90, 8),
('Flamy', 58, 64, 80, 58, 65, 80, 8),
('Leafy', 45, 55, 75, 50, 65, 45, 8),
('Watery', 50, 65, 85, 64, 70, 44, 8),
('Windy', 40, 45, 35, 40, 35, 56, 3),
('Ratty', 30, 56, 25, 35, 35, 72, 3),
('Batty', 35, 45, 30, 40, 40, 55, 3);

-- Assigning Pokémon to boxes
INSERT INTO has_box (pkmn_id, box_id) VALUES
(1, 1),
(2, 1),
(8, 1),
(3, 17),
(4, 33),
(5, 33),
(6, 33),
(7, 33),
(9, 33),
(10, 1),
(11, 1),
(12, 1);

-- Assigning species to collected Pokémon
INSERT INTO has_species (pkmn_id, pkmn_name) VALUES
(1, 'pikachu'),
(2, 'bulbasaur'),
(3, 'charmander'),
(4, 'squirtle'),
(5, 'eevee'),
(6, 'pikachu'),
(7, 'charmander'),
(8, 'bulbasaur'),
(9, 'squirtle'),
(10, 'pidgey'),
(11, 'rattata'),
(12, 'zubat');

INSERT INTO has_nature (pkmn_id, nature_name) VALUES
(1, 'serious');