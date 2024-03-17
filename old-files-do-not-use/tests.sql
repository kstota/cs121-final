-- Inserting users
CALL sp_add_client('ashketch', 'gottacatch');
CALL sp_add_client('mistywat', 'cerulean');
CALL sp_add_admin('brockrock', 'single4ever');

-- Inserting collected Pokemon
CALL sp_add_to_box('ashketch', 'pikachu', 'Pika', 1, 21, 11, 11, 11, 13, 15, 5, 'serious');
CALL sp_add_to_box('ashketch', 'dialga', 'Timely', 1, 247, 162, 258, 209, 155, 149, 65, 'modest');
CALL sp_add_to_box('brockrock', 'onix', 'Rocky', 1, 100, 77, 59, 178, 53, 88, 45, 'lax');
CALL sp_add_to_box('brockrock', 'golem', 'Baller', 1, 239, 240, 104, 236, 132, 101, 80, 'adamant');
CALL sp_add_to_box('mistywat', 'starmie', 'starburst', 1, 178, 94, 201, 139, 141, 244, 67, 'timid');