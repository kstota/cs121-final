-- Delete tables if they already exist. Order respects referential integrity. 
DROP TABLE IF EXISTS type_weaknesses;
DROP TABLE IF EXISTS has_box;
DROP TABLE IF EXISTS has_nature;
DROP TABLE IF EXISTS has_species;
DROP TABLE IF EXISTS box_owner;
DROP TABLE IF EXISTS collected; 
DROP TABLE IF EXISTS nature;
DROP TABLE IF EXISTS pokedex;
DROP TABLE IF EXISTS boxes;
DROP TABLE IF EXISTS users;

-- This table holds information for authenticating users based on
-- a password. Passwords are not stored plaintext so that they
-- cannot be used by people that shouldn't have them.
CREATE TABLE users (
    -- Usernames are up to 10 characters.
    user_id VARCHAR(10) PRIMARY KEY,
    -- Salt will be 8 characters all the time, so we can make this 8.
    salt CHAR(8) NOT NULL,
    -- We use SHA-2 with 256-bit hashes. 
    password_hash BINARY(64) NOT NULL,
    -- if admin, is_admin role attribute is 1
    is_admin TINYINT NOT NULL
);

-- This table holds basic information for boxes (box_id and num_pokemon).
CREATE TABLE boxes (
    -- box_id, auto_incrementing integer column. 
    box_id INT AUTO_INCREMENT,
    -- number of pokemon contained in box
    num_pokemon INT NOT NULL DEFAULT 0,
    -- set box_id to be the primary key of this table
    PRIMARY KEY (box_id)
);

-- This table relates boxes to the user that owns them.
CREATE TABLE box_owner (
    -- box_id, auto_incrementing integer column. 
    box_id INT PRIMARY KEY,
    -- Usernames are up to 10 characters
    user_id VARCHAR(10) NOT NULL,
    -- box_id and user_id are set as foreign keys
    -- CASCADE constraints added here (updates and deletes)
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, 
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- This table contains the base stat values for every pokemon that can be 
-- stored in a box (i.e. a pokedex-style table). 
CREATE TABLE pokedex (
    -- name of the pokemon (e.g. gastrodon)
    pkmn_name VARCHAR(30) PRIMARY KEY,
    -- official pokedex number (e.g. 423)
    pokedex_number INT NOT NULL, 
    -- type 1 of the pokemon (e.g. water)
    type_1 VARCHAR(10) NOT NULL, 
    -- type 2 of the pokemon (e.g. ground). Can be NULL
    type_2 VARCHAR(10), 
    -- base hp for the given Pokemon species 
    base_hp INT NOT NULL, 
    -- base attack for the given Pokemon species 
    base_attack INT NOT NULL, 
    -- base special attack for the given Pokemon species 
    base_special_attack INT NOT NULL, 
    -- base defense for the given Pokemon species 
    base_defense INT NOT NULL, 
    -- base special defense for the given Pokemon species 
    base_special_defense INT NOT NULL, 
    -- base speed for the given Pokemon species 
    base_speed INT NOT NULL
);

-- This table stores the multipliers conferred to the stats of a Pokemon 
-- depending on its nature (25 in total).
CREATE TABLE nature (
    -- Nature (does not exceed 10 characters)
    nature_name VARCHAR(10) PRIMARY KEY,
    -- multiplier conferred on attack stat by given nature
    attack_mult DECIMAL(2, 1) NOT NULL, 
    -- multiplier conferred on special attack stat by given nature
    special_attack_mult DECIMAL(2, 1) NOT NULL, 
    -- multiplier conferred on defense stat by given nature
    defense_mult DECIMAL(2, 1) NOT NULL, 
    -- multiplier conferred on special defense stat by given nature
    special_defense_mult DECIMAL(2, 1) NOT NULL, 
    -- multiplier conferred on speed stat by given nature
    speed_mult DECIMAL(2, 1) NOT NULL 
);

-- This table stores Pokemon-specific values for each Pokemon stored in the box
-- system, including its unique pkmn_id identifier, nickname, and stat values.
CREATE TABLE collected (
    -- Unique pokemon_id, auto-incrementing integer column
    pkmn_id INT AUTO_INCREMENT,
    -- nickname for the pokemon (e.g "Sluggy")
    pkmn_nickname VARCHAR(30), 
    -- pokemon hitpoint (hp) stat
    hp INT NOT NULL,
    -- pokemon attack stat
    attack INT NOT NULL,
    -- pokemon special attack stat
    special_attack INT NOT NULL,
    -- pokemon defense stat
    defense INT NOT NULL,
    -- pokemon special defense stat
    special_defense INT NOT NULL,
    -- pokemon speed stat
    speed INT NOT NULL,
    -- pokemon's level
    lvl INT NOT NULL,
    -- flag denoting whether the Pokemon is detected to be hacked or not
    -- (1 if hacked, 0 if not hacked)
    is_hacked TINYINT,
    -- set pkmn_id to be the primary key of this table
    PRIMARY KEY (pkmn_id)
);

-- This table relates the each Pokemon stored in the box system to its nature, 
-- using its unique pkmn_id identifier and one of 25 natures.
CREATE TABLE has_nature (
    -- Unique pokemon_id
    pkmn_id INT PRIMARY KEY,
    -- pokemon's nature
    nature_name VARCHAR(10), 
    -- pkmn_id and nature_name are set as foreign keys 
    -- CASCADE constraints added here (updates and deletes)
    FOREIGN KEY (pkmn_id) REFERENCES collected(pkmn_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (nature_name) REFERENCES nature(nature_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- This table relates the each Pokemon stored in the box system to the box 
-- it is contained in, using its unique pkmn_id and the unique box_id. 
CREATE TABLE has_box (
    -- Unique pokemon_id
    pkmn_id INT PRIMARY KEY,
    -- pokemon's nature
    box_id INT, 
    -- pkmn_id and box_id are set as foreign keys 
    -- CASCADE constraints added here (updates and deletes)
    FOREIGN KEY (pkmn_id) REFERENCES collected(pkmn_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- This table relates the each Pokemon stored in the box system to its name 
-- (i.e. "species"), using its unique pkmn_id identifier and pkmn_name.
CREATE TABLE has_species (
    -- Unique pokemon_id
    pkmn_id INT PRIMARY KEY,
    -- pokemon's nature
    pkmn_name VARCHAR(10), 
    -- pkmn_id and pkmn_name are set as foreign keys 
    -- CASCADE constraints added here (updates and deletes)
    FOREIGN KEY (pkmn_id) REFERENCES collected(pkmn_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (pkmn_name) REFERENCES pokedex(pkmn_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- This table contains the stat multipliers for defending types against every
-- attacking type. 
CREATE TABLE type_weaknesses (
    -- defending type name (one of 18 total types, just like with Pokemon)
    defending_type VARCHAR(10),
    -- attack type (one of 18 total types, just like with Pokemon)
    attack_type VARCHAR(10),
    -- multiplier for an attack of this type against the defending type 
    attack_multiplier DECIMAL(2, 1),
    -- make primary key (defending_type, attack_type) since we want there to be
    -- exactly one row per pair of types to encode their relationship
    PRIMARY KEY (defending_type, attack_type)
);
