-- This script loads in 3 CSV files to fill the pokedex, nature, and 
-- type_weaknesses tables. 

-- read in pokedex data
LOAD DATA LOCAL INFILE 'pokedex.csv' INTO TABLE pokedex
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED 
BY '\r\n' IGNORE 1 ROWS;

-- set second types to NULL for Pokemon with no second type
UPDATE pokedex SET type_2 = NULLIF(type_2, '');

-- read in nature data
LOAD DATA LOCAL INFILE 'nature.csv' INTO TABLE nature
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED 
BY '\r\n' IGNORE 1 ROWS;

-- read in type_weaknesses data
LOAD DATA LOCAL INFILE 'type_weaknesses.csv' INTO TABLE type_weaknesses
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED 
BY '\r\n' IGNORE 1 ROWS;

-- CREATE EXAMPLE USERS
CALL sp_add_client('ashketch', 'gottacatch');
CALL sp_add_client('mistywat', 'cerulean');
CALL sp_add_client('brockrock', 'single4ever');
CALL sp_add_admin('profoak', 'bestgrandpa');
CALL sp_add_client('teamrocket', 'blastingoff');

-- ADD UNHACKED POKEMON INTO THE FIRST 4 BOXES OF EACH USER
CALL sp_add_to_box('profoak', 'lileep', 'rando1', 3, 229, 101, 150, 145, 157, 59, 76, 'hardy');
CALL sp_add_to_box('profoak', 'voltorb', 'rando2', 3, 61, 21, 38, 51, 59, 68, 27, 'jolly');
CALL sp_add_to_box('teamrocket', 'mareep', 'rando3', 3, 63, 24, 40, 44, 34, 27, 23, 'naive');
CALL sp_add_to_box('profoak', 'growlithe', 'rando4', 2, 116, 77, 97, 54, 62, 108, 50, 'calm');
CALL sp_add_to_box('profoak', 'duskull', 'rando5', 4, 190, 110, 67, 150, 227, 66, 86, 'hasty');
CALL sp_add_to_box('teamrocket', 'phione', 'rando6', 4, 190, 126, 143, 137, 119, 116, 62, 'bashful');
CALL sp_add_to_box('mistywat', 'weezing', 'rando7', 1, 173, 163, 114, 175, 147, 104, 64, 'brave');
CALL sp_add_to_box('profoak', 'cacnea', 'rando8', 2, 144, 100, 99, 48, 89, 45, 50, 'hardy');
CALL sp_add_to_box('teamrocket', 'wormadam-t', 'rando9', 3, 122, 96, 72, 98, 119, 45, 44, 'jolly');
CALL sp_add_to_box('mistywat', 'turtwig', 'rando10', 2, 38, 22, 17, 20, 18, 12, 10, 'sassy');
CALL sp_add_to_box('brockrock', 'sunkern', 'rando11', 4, 176, 124, 70, 81, 117, 79, 88, 'calm');
CALL sp_add_to_box('profoak', 'onix', 'rando12', 4, 153, 51, 83, 223, 75, 100, 58, 'bold');
CALL sp_add_to_box('teamrocket', 'deoxys-a', 'rando13', 4, 138, 247, 258, 49, 57, 247, 63, 'gentle');
CALL sp_add_to_box('profoak', 'huntail', 'rando14', 3, 105, 137, 78, 102, 85, 80, 43, 'adamant');
CALL sp_add_to_box('brockrock', 'cacnea', 'rando15', 3, 175, 132, 135, 98, 85, 119, 70, 'docile');
CALL sp_add_to_box('brockrock', 'drapion', 'rando16', 3, 247, 161, 108, 187, 147, 160, 76, 'rash');
CALL sp_add_to_box('teamrocket', 'spheal', 'rando17', 4, 162, 57, 71, 91, 61, 61, 54, 'hasty');
CALL sp_add_to_box('mistywat', 'yanma', 'rando18', 4, 164, 97, 126, 65, 94, 141, 58, 'naive');
CALL sp_add_to_box('mistywat', 'aipom', 'rando19', 3, 54, 30, 34, 28, 29, 54, 20, 'calm');
CALL sp_add_to_box('teamrocket', 'numel', 'rando20', 1, 258, 166, 113, 89, 103, 86, 79, 'adamant');
CALL sp_add_to_box('profoak', 'carnivine', 'rando21', 2, 61, 43, 39, 49, 49, 27, 19, 'bold');
CALL sp_add_to_box('mistywat', 'nidorino', 'rando22', 4, 96, 74, 44, 61, 48, 52, 32, 'hardy');
CALL sp_add_to_box('mistywat', 'swampert', 'rando23', 2, 44, 37, 30, 24, 31, 20, 11, 'mild');
CALL sp_add_to_box('brockrock', 'mantyke', 'rando24', 4, 207, 61, 118, 141, 249, 87, 82, 'careful');
CALL sp_add_to_box('brockrock', 'abomasnow', 'rando25', 4, 53, 46, 33, 28, 44, 20, 15, 'sassy');
CALL sp_add_to_box('mistywat', 'kyogre', 'rando26', 2, 181, 130, 195, 145, 210, 107, 56, 'bashful');
CALL sp_add_to_box('profoak', 'magikarp', 'rando27', 2, 160, 41, 34, 125, 46, 200, 82, 'naughty');
CALL sp_add_to_box('mistywat', 'koffing', 'rando28', 1, 133, 133, 104, 146, 93, 68, 68, 'hardy');
CALL sp_add_to_box('mistywat', 'larvitar', 'rando29', 1, 102, 50, 58, 45, 42, 41, 34, 'bashful');
CALL sp_add_to_box('profoak', 'scyther', 'rando30', 2, 221, 228, 100, 123, 120, 163, 68, 'naughty');
CALL sp_add_to_box('teamrocket', 'wartortle', 'rando31', 2, 82, 60, 74, 66, 57, 69, 33, 'naughty');
CALL sp_add_to_box('brockrock', 'grovyle', 'rando32', 2, 125, 84, 145, 76, 76, 101, 50, 'mild');
CALL sp_add_to_box('profoak', 'dusknoir', 'rando33', 3, 71, 71, 52, 88, 80, 54, 28, 'hardy');
CALL sp_add_to_box('teamrocket', 'mightyena', 'rando34', 4, 128, 79, 60, 73, 53, 72, 37, 'quirky');
CALL sp_add_to_box('brockrock', 'qwilfish', 'rando35', 3, 164, 162, 92, 102, 107, 122, 60, 'docile');
CALL sp_add_to_box('brockrock', 'froslass', 'rando36', 1, 45, 27, 39, 28, 32, 37, 14, 'calm');
CALL sp_add_to_box('mistywat', 'vulpix', 'rando37', 1, 66, 47, 36, 45, 50, 45, 28, 'relaxed');
CALL sp_add_to_box('brockrock', 'relicanth', 'rando38', 1, 290, 172, 159, 263, 163, 114, 88, 'bold');
CALL sp_add_to_box('mistywat', 'combusken', 'rando39', 2, 129, 134, 87, 94, 77, 65, 48, 'brave');
CALL sp_add_to_box('mistywat', 'growlithe', 'rando40', 4, 38, 23, 21, 18, 14, 23, 10, 'lax');
CALL sp_add_to_box('mistywat', 'staravia', 'rando41', 3, 234, 134, 98, 117, 120, 157, 82, 'lax');
CALL sp_add_to_box('teamrocket', 'pachirisu', 'rando42', 4, 227, 112, 91, 141, 205, 248, 87, 'jolly');
CALL sp_add_to_box('brockrock', 'swampert', 'rando43', 3, 141, 101, 114, 87, 96, 66, 41, 'mild');
CALL sp_add_to_box('teamrocket', 'rotom-s', 'rando44', 3, 163, 111, 150, 203, 162, 175, 69, 'impish');
CALL sp_add_to_box('teamrocket', 'starmie', 'rando45', 1, 228, 190, 174, 138, 160, 210, 77, 'docile');

-- MODIFIED VALUES --> HACKED POKEMON
CALL sp_add_to_box('teamrocket', 'altaria', 'rando46', 1, 45, 24, 50, 31, 38, 28, 12, 'relaxed');
CALL sp_add_to_box('teamrocket', 'wailmer', 'rando47', 2, 228, 130, 120, 95, 67, 118, 59, 'mild');
CALL sp_add_to_box('teamrocket', 'nincada', 'rando48', 4, 95, 66, 40, 84, 32, 45, 200, 'bold');
CALL sp_add_to_box('teamrocket', 'trapinch', 'rando49', 4, 188, 240, 103, 150, 141, 105, 90, 'adamant');
CALL sp_add_to_box('teamrocket', 'noctowl', 'rando50', 4, 170, 120, 117, 64, 108, 104, 52, 'naive');

