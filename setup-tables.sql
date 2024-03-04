-- Delete tables if they already exist. Order respects referential integrity. 
DROP TABLE IF EXISTS type_weaknesses;
DROP TABLE IF EXISTS collected; 
DROP TABLE IF EXISTS nature;
DROP TABLE IF EXISTS pokedex;
DROP TABLE IF EXISTS boxes;
DROP TABLE IF EXISTS user;

-- This table holds information for authenticating users based on
-- a password. Passwords are not stored plaintext so that they
-- cannot be used by people that shouldn't have them.
CREATE TABLE user (
    -- Usernames are up to 10 characters.
    user_id VARCHAR(10) PRIMARY KEY,
    -- Salt will be 8 characters all the time, so we can make this 8.
    salt CHAR(8) NOT NULL,
    -- We use SHA-2 with 256-bit hashes. 
    password_hash BINARY(64) NOT NULL,
    -- if admin, is_admin role attribute is 1
    is_admin TINYINT(1) NOT NULL
);

-- This table relates boxes to the user that owns them.
CREATE TABLE boxes (
    -- box_id, auto_incrementing integer column. 
    box_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    -- Usernames are up to 10 characters
    user_id VARCHAR(10) NOT NULL,
    -- user_id is set as foreign key
    -- CASCADE constraints added here (updates and deletes)
    FOREIGN KEY (user_id) REFERENCES user(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- This table contains the stat multipliers for defending types against every
-- attacking type. 
CREATE TABLE type_weaknesses (
    -- defending type name. only one row per type --> primary key 
    pkmn_type VARCHAR(10) PRIMARY KEY,
    -- multiplier for a normal type attack against the defending type 
    normal DECIMAL(2, 1),
    -- multiplier for a fire type attack against the defending type 
    fire DECIMAL(2, 1),
    -- multiplier for a water type attack against the defending type 
    water DECIMAL(2, 1),
    -- multiplier for an electric type attack against the defending type 
    electric DECIMAL(2, 1),
    -- multiplier for a grass type attack against the defending type 
    grass DECIMAL(2, 1),
    -- multiplier for an ice type attack against the defending type 
    ice DECIMAL(2, 1),
    -- multiplier for a fighting type attack against the defending type 
    fighting DECIMAL(2, 1),
    -- multiplier for a poison type attack against the defending type 
    poison DECIMAL(2, 1),
    -- multiplier for a ground type attack against the defending type 
    ground DECIMAL(2, 1),
    -- multiplier for a flying type attack against the defending type 
    flying DECIMAL(2, 1),
    -- multiplier for a psychic type attack against the defending type 
    psychic DECIMAL(2, 1),
    -- multiplier for a bug type attack against the defending type 
    bug DECIMAL(2, 1),
    -- multiplier for a rock type attack against the defending type 
    rock DECIMAL(2, 1),
    -- multiplier for a ghost type attack against the defending type 
    ghost DECIMAL(2, 1),
    -- multiplier for a dragon type attack against the defending type 
    dragon DECIMAL(2, 1),
    -- multiplier for a dark type attack against the defending type 
    dark DECIMAL(2, 1),
    -- multiplier for a steel type attack against the defending type 
    steel DECIMAL(2, 1),
    -- multiplier for a fairy type attack against the defending type 
    fairy DECIMAL(2, 1)
);

-- This table contains the base stat values for every pokemon that can be 
-- stored in a box (i.e. a pokedex-style table). 
CREATE TABLE pokedex (
    -- name of the pokemon (e.g. gastrodon)
    pkmn_name VARCHAR(30) PRIMARY KEY,
    -- type 1 of the pokemon (e.g. water)
    type_1 VARCHAR(10) NOT NULL, 
    -- type 2 of the pokemon (e.g. ground). Can be NULL
    type_2 VARCHAR(10), 
    -- base hp for the given Pokemon species 
    base_hp INTEGER NOT NULL, 
    -- base attack for the given Pokemon species 
    base_attack INTEGER NOT NULL, 
    -- base special attack for the given Pokemon species 
    base_special_attack INTEGER NOT NULL, 
    -- base defense for the given Pokemon species 
    base_defense INTEGER NOT NULL, 
    -- base special defense for the given Pokemon species 
    base_special_defense INTEGER NOT NULL, 
    -- base speed for the given Pokemon species 
    base_speed INTEGER NOT NULL
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

-- This table stores information for each Pokemon stored in the box system, 
-- including its unique pkmn_id identifier, the box it is stored in, its name, 
-- nickname, stat values (note: distinct from the base stats values), nature,
-- and level.
CREATE TABLE collected (
    -- Unique pokemon_id, auto-incrementing integer column
    pkmn_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    -- box_id (unique box identifier)
    box_id INTEGER, 
    -- name of the pokemon (e.g. gastrodon)
    pkmn_name VARCHAR(30), 
    -- nickname for the pokemon (e.g "Sluggy")
    pkmn_nickname VARCHAR(30), 
    -- pokemon hitpoint (hp) stat
    hp INTEGER,
    -- pokemon attack stat
    attack INTEGER,
    -- pokemon special attack stat
    special_attack INTEGER,
    -- pokemon defense stat
    defense INTEGER,
    -- pokemon special defense stat
    special_defense INTEGER,
    -- pokemon speed stat
    speed INTEGER,
    -- pokemon's nature
    nature_name VARCHAR(10), 
    -- pokemon's level 
    lvl INTEGER,

    -- box_id, pkmn_name, and nature_name are set as foreign keys 
    -- box_id from boxes, pkmn_name from pokedex, and nature_name from 
    -- nature
    -- CASCADE constraints added here (updates and deletes)
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    FOREIGN KEY (pkmn_name) REFERENCES pokedex(pkmn_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    FOREIGN KEY (nature_name) REFERENCES nature(nature_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- unhacked, base stats
INSERT INTO collected VALUES ('bulbasaur', 45, 49, 49, 65, 65, 45, 'bashful', 50);
-- unhacked, 252 HP / 252 SPA / 4 SpD, 31 IV for all except atk (0 IV atk)
INSERT INTO collected VALUES ('torkoal', 177, 90, 160, 150, 91, 36, 'quiet', 50);
-- unhacked, random EV spread, IV = 16 for all 
INSERT INTO collected VALUES ('pikachu', 174, 101, 98, 95, 124, 154, 'serious', 74);
-- hacked
INSERT INTO collected VALUES ('arceus', 435, 435, 435, 435, 435, 435, 'docile', 50);

INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('normal', 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('fire', 1.0, 0.5, 2.0, 1.0, 0.5, 0.5, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 0.5, 0.5);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('water', 1.0, 0.5, 0.5, 2.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('electric', 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('grass', 1.0, 2.0, 0.5, 0.5, 0.5, 2.0, 1.0, 2.0, 0.5, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('ice', 1.0, 2.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 2.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('fighting', 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 0.5, 0.5, 1.0, 1.0, 0.5, 1.0, 2.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('poison', 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 0.5, 0.5, 2.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('ground', 1.0, 1.0, 2.0, 0.0, 2.0, 2.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('flying', 1.0, 1.0, 1.0, 2.0, 0.5, 2.0, 0.5, 1.0, 0.0, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('psychic', 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('bug', 1.0, 2.0, 1.0, 1.0, 0.5, 1.0, 0.5, 1.0, 0.5, 2.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('rock', 0.5, 0.5, 2.0, 1.0, 2.0, 1.0, 2.0, 0.5, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('ghost', 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('dragon', 1.0, 0.5, 0.5, 0.5, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 2.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('dark', 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 0.0, 2.0, 1.0, 0.5, 1.0, 0.5, 1.0, 2.0);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('steel', 0.5, 2.0, 1.0, 1.0, 0.5, 0.5, 2.0, 1.0, 2.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 1.0, 0.5, 0.5);
INSERT INTO type_weaknesses (pkmn_type, normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy) VALUES ('fairy', 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 0.0, 0.5, 2.0, 1.0);

INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bulbasaur', 'grass', 'poison', 45, 49, 49, 65, 65, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ivysaur', 'grass', 'poison', 60, 62, 63, 80, 80, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('venusaur', 'grass', 'poison', 80, 82, 83, 100, 100, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('charmander', 'fire', 39, 52, 43, 60, 50, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('charmeleon', 'fire', 58, 64, 58, 80, 65, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('charizard', 'fire', 'flying', 78, 84, 78, 109, 85, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('squirtle', 'water', 44, 48, 65, 50, 64, 43);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wartortle', 'water', 59, 63, 80, 65, 80, 58);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('blastoise', 'water', 79, 83, 100, 85, 105, 78);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('caterpie', 'bug', 45, 30, 35, 20, 20, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('metapod', 'bug', 50, 20, 55, 25, 25, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('butterfree', 'bug', 'flying', 60, 45, 50, 90, 80, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('weedle', 'bug', 'poison', 40, 35, 30, 20, 20, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kakuna', 'bug', 'poison', 45, 25, 50, 25, 25, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('beedrill', 'bug', 'poison', 65, 90, 40, 45, 80, 75);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pidgey', 'normal', 'flying', 40, 45, 40, 35, 35, 56);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pidgeotto', 'normal', 'flying', 63, 60, 55, 50, 50, 71);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pidgeot', 'normal', 'flying', 83, 80, 75, 70, 70, 101);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rattata', 'normal', 30, 56, 35, 25, 35, 72);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('raticate', 'normal', 55, 81, 60, 50, 70, 97);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('spearow', 'normal', 'flying', 40, 60, 30, 31, 31, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('fearow', 'normal', 'flying', 65, 90, 65, 61, 61, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ekans', 'poison', 35, 60, 44, 40, 54, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('arbok', 'poison', 60, 85, 69, 65, 79, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pikachu', 'electric', 35, 55, 40, 50, 50, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('raichu', 'electric', 60, 90, 55, 90, 80, 110);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sandshrew', 'ground', 50, 75, 85, 20, 30, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sandslash', 'ground', 75, 100, 110, 45, 55, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nidoran-f', 'poison', 55, 47, 52, 40, 40, 41);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nidorina', 'poison', 70, 62, 67, 55, 55, 56);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nidoqueen', 'poison', 'ground', 90, 92, 87, 75, 85, 76);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nidoran-m', 'poison', 46, 57, 40, 40, 40, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nidorino', 'poison', 61, 72, 57, 55, 55, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nidoking', 'poison', 'ground', 81, 102, 77, 85, 75, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('clefairy', 'fairy', 70, 45, 48, 60, 65, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('clefable', 'fairy', 95, 70, 73, 95, 90, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('vulpix', 'fire', 38, 41, 40, 50, 65, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ninetales', 'fire', 73, 76, 75, 81, 100, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('jigglypuff', 'normal', 'fairy', 115, 45, 20, 45, 25, 20);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wigglytuff', 'normal', 'fairy', 140, 70, 45, 85, 50, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('zubat', 'poison', 'flying', 40, 45, 35, 30, 40, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('golbat', 'poison', 'flying', 75, 80, 70, 65, 75, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('oddish', 'grass', 'poison', 45, 50, 55, 75, 65, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gloom', 'grass', 'poison', 60, 65, 70, 85, 75, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('vileplume', 'grass', 'poison', 75, 80, 85, 110, 90, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('paras', 'bug', 'grass', 35, 70, 55, 45, 55, 25);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('parasect', 'bug', 'grass', 60, 95, 80, 60, 80, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('venonat', 'bug', 'poison', 60, 55, 50, 40, 55, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('venomoth', 'bug', 'poison', 70, 65, 60, 90, 75, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('diglett', 'ground', 10, 55, 25, 35, 45, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dugtrio', 'ground', 35, 80, 50, 50, 70, 120);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('meowth', 'normal', 40, 45, 35, 40, 40, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('persian', 'normal', 65, 70, 60, 65, 65, 115);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('psyduck', 'water', 50, 52, 48, 65, 50, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('golduck', 'water', 80, 82, 78, 95, 80, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mankey', 'fighting', 40, 80, 35, 35, 45, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('primeape', 'fighting', 65, 105, 60, 60, 70, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('growlithe', 'fire', 55, 70, 45, 70, 50, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('arcanine', 'fire', 90, 110, 80, 100, 80, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('poliwag', 'water', 40, 50, 40, 40, 40, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('poliwhirl', 'water', 65, 65, 65, 50, 50, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('poliwrath', 'water', 'fighting', 90, 95, 95, 70, 90, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('abra', 'psychic', 25, 20, 15, 105, 55, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kadabra', 'psychic', 40, 35, 30, 120, 70, 105);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('alakazam', 'psychic', 55, 50, 45, 135, 95, 120);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('machop', 'fighting', 70, 80, 50, 35, 35, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('machoke', 'fighting', 80, 100, 70, 50, 60, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('machamp', 'fighting', 90, 130, 80, 65, 85, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bellsprout', 'grass', 'poison', 50, 75, 35, 70, 30, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('weepinbell', 'grass', 'poison', 65, 90, 50, 85, 45, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('victreebel', 'grass', 'poison', 80, 105, 65, 100, 70, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tentacool', 'water', 'poison', 40, 40, 35, 50, 100, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tentacruel', 'water', 'poison', 80, 70, 65, 80, 120, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('geodude', 'rock', 'ground', 40, 80, 100, 30, 30, 20);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('graveler', 'rock', 'ground', 55, 95, 115, 45, 45, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('golem', 'rock', 'ground', 80, 120, 130, 55, 65, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ponyta', 'fire', 50, 85, 55, 65, 65, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rapidash', 'fire', 65, 100, 70, 80, 80, 105);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('slowpoke', 'water', 'psychic', 90, 65, 65, 40, 40, 15);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('slowbro', 'water', 'psychic', 95, 75, 110, 100, 80, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magnemite', 'electric', 'steel', 25, 35, 70, 95, 55, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magneton', 'electric', 'steel', 50, 60, 95, 120, 70, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('farfetchd', 'normal', 'flying', 52, 65, 55, 58, 62, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('doduo', 'normal', 'flying', 35, 85, 45, 35, 35, 75);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dodrio', 'normal', 'flying', 60, 110, 70, 60, 60, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('seel', 'water', 65, 45, 55, 45, 70, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dewgong', 'water', 'ice', 90, 70, 80, 70, 95, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('grimer', 'poison', 80, 80, 50, 40, 50, 25);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('muk', 'poison', 105, 105, 75, 65, 100, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shellder', 'water', 30, 65, 100, 45, 25, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cloyster', 'water', 'ice', 50, 95, 180, 85, 45, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gastly', 'ghost', 'poison', 30, 35, 30, 100, 35, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('haunter', 'ghost', 'poison', 45, 50, 45, 115, 55, 95);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gengar', 'ghost', 'poison', 60, 65, 60, 130, 75, 110);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('onix', 'rock', 'ground', 35, 45, 160, 30, 45, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('drowzee', 'psychic', 60, 48, 45, 43, 90, 42);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hypno', 'psychic', 85, 73, 70, 73, 115, 67);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('krabby', 'water', 30, 105, 90, 25, 25, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kingler', 'water', 55, 130, 115, 50, 50, 75);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('voltorb', 'electric', 40, 30, 50, 55, 55, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('electrode', 'electric', 60, 50, 70, 80, 80, 140);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('exeggcute', 'grass', 'psychic', 60, 40, 80, 60, 45, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('exeggutor', 'grass', 'psychic', 95, 95, 85, 125, 65, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cubone', 'ground', 50, 50, 95, 40, 50, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('marowak', 'ground', 60, 80, 110, 50, 80, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hitmonlee', 'fighting', 50, 120, 53, 35, 110, 87);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hitmonchan', 'fighting', 50, 105, 79, 35, 110, 76);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lickitung', 'normal', 90, 55, 75, 60, 75, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('koffing', 'poison', 40, 65, 95, 60, 45, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('weezing', 'poison', 65, 90, 120, 85, 70, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rhyhorn', 'ground', 'rock', 80, 85, 95, 30, 30, 25);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rhydon', 'ground', 'rock', 105, 130, 120, 45, 45, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chansey', 'normal', 250, 5, 5, 35, 105, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tangela', 'grass', 65, 55, 115, 100, 40, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kangaskhan', 'normal', 105, 95, 80, 40, 80, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('horsea', 'water', 30, 40, 70, 70, 25, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('seadra', 'water', 55, 65, 95, 95, 45, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('goldeen', 'water', 45, 67, 60, 35, 50, 63);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('seaking', 'water', 80, 92, 65, 65, 80, 68);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('staryu', 'water', 30, 45, 55, 70, 55, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('starmie', 'water', 'psychic', 60, 75, 85, 100, 85, 115);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mr. mime', 'psychic', 'fairy', 40, 45, 65, 100, 120, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('scyther', 'bug', 'flying', 70, 110, 80, 55, 80, 105);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('jynx', 'ice', 'psychic', 65, 50, 35, 115, 95, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('electabuzz', 'electric', 65, 83, 57, 95, 85, 105);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magmar', 'fire', 65, 95, 57, 100, 85, 93);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pinsir', 'bug', 65, 125, 100, 55, 70, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tauros', 'normal', 75, 100, 95, 40, 70, 110);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magikarp', 'water', 20, 10, 55, 15, 20, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gyarados', 'water', 'flying', 95, 125, 79, 60, 100, 81);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lapras', 'water', 'ice', 130, 85, 80, 85, 95, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ditto', 'normal', 48, 48, 48, 48, 48, 48);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('eevee', 'normal', 55, 55, 50, 45, 65, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('vaporeon', 'water', 130, 65, 60, 110, 95, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('jolteon', 'electric', 65, 65, 60, 110, 95, 130);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('flareon', 'fire', 65, 130, 60, 95, 110, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('porygon', 'normal', 65, 60, 70, 85, 75, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('omanyte', 'rock', 'water', 35, 40, 100, 90, 55, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('omastar', 'rock', 'water', 70, 60, 125, 115, 70, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kabuto', 'rock', 'water', 30, 80, 90, 55, 45, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kabutops', 'rock', 'water', 60, 115, 105, 65, 70, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('aerodactyl', 'rock', 'flying', 80, 105, 65, 60, 75, 130);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('snorlax', 'normal', 160, 110, 65, 65, 110, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('articuno', 'ice', 'flying', 90, 85, 100, 95, 125, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('zapdos', 'electric', 'flying', 90, 90, 85, 125, 90, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('moltres', 'fire', 'flying', 90, 100, 90, 125, 85, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dratini', 'dragon', 41, 64, 45, 50, 50, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dragonair', 'dragon', 61, 84, 65, 70, 70, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dragonite', 'dragon', 'flying', 91, 134, 95, 100, 100, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mewtwo', 'psychic', 106, 110, 90, 154, 90, 130);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mew', 'psychic', 100, 100, 100, 100, 100, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chikorita', 'grass', 45, 49, 65, 49, 65, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bayleef', 'grass', 60, 62, 80, 63, 80, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cyndaquil', 'fire', 39, 52, 43, 60, 50, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('quilava', 'fire', 58, 64, 58, 80, 65, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('typhlosion', 'fire', 78, 84, 78, 109, 85, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('totodile', 'water', 50, 65, 64, 44, 48, 43);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('croconaw', 'water', 65, 80, 80, 59, 63, 58);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('feraligatr', 'water', 85, 105, 100, 79, 83, 78);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sentret', 'normal', 35, 46, 34, 35, 45, 20);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('furret', 'normal', 85, 76, 64, 45, 55, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hoothoot', 'normal', 'flying', 60, 30, 30, 36, 56, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('noctowl', 'normal', 'flying', 100, 50, 50, 76, 96, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ledyba', 'bug', 'flying', 40, 20, 30, 40, 80, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ledian', 'bug', 'flying', 55, 35, 50, 55, 110, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('spinarak', 'bug', 'poison', 40, 60, 40, 40, 40, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ariados', 'bug', 'poison', 70, 90, 70, 60, 60, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('crobat', 'poison', 'flying', 85, 90, 80, 70, 80, 130);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chinchou', 'water', 'electric', 75, 38, 38, 56, 56, 67);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lanturn', 'water', 'electric', 125, 58, 58, 76, 76, 67);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pichu', 'electric', 20, 40, 15, 35, 35, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cleffa', 'fairy', 50, 25, 28, 45, 55, 15);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('igglybuff', 'normal', 'fairy', 90, 30, 15, 40, 20, 15);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('togepi', 'fairy', 35, 20, 65, 40, 65, 20);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('togetic', 'fairy', 'flying', 55, 40, 85, 80, 105, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('natu', 'psychic', 'flying', 40, 50, 45, 70, 45, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('xatu', 'psychic', 'flying', 65, 75, 70, 95, 70, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mareep', 'electric', 55, 40, 40, 65, 45, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('flaaffy', 'electric', 70, 55, 55, 80, 60, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ampharos', 'electric', 90, 75, 85, 115, 90, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bellossom', 'grass', 75, 80, 95, 90, 100, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('marill', 'water', 'fairy', 70, 20, 50, 20, 50, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('azumarill', 'water', 'fairy', 100, 50, 80, 60, 80, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sudowoodo', 'rock', 70, 100, 115, 30, 65, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('politoed', 'water', 90, 75, 75, 90, 100, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hoppip', 'grass', 'flying', 35, 35, 40, 35, 55, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('skiploom', 'grass', 'flying', 55, 45, 50, 45, 65, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('jumpluff', 'grass', 'flying', 75, 55, 70, 55, 95, 110);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('aipom', 'normal', 55, 70, 55, 40, 55, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sunkern', 'grass', 30, 30, 30, 30, 30, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sunflora', 'grass', 75, 75, 55, 105, 85, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('yanma', 'bug', 'flying', 65, 65, 45, 75, 45, 95);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wooper', 'water', 'ground', 55, 45, 45, 25, 25, 15);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('quagsire', 'water', 'ground', 95, 85, 85, 65, 65, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('espeon', 'psychic', 65, 65, 60, 130, 95, 110);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('umbreon', 'dark', 95, 65, 110, 60, 130, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('murkrow', 'dark', 'flying', 60, 85, 42, 85, 42, 91);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('slowking', 'water', 'psychic', 95, 75, 80, 100, 110, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('misdreavus', 'ghost', 60, 60, 60, 85, 85, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('unown', 'psychic', 48, 72, 48, 72, 48, 48);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wobbuffet', 'psychic', 190, 33, 58, 33, 58, 33);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('girafarig', 'normal', 'psychic', 70, 80, 65, 90, 65, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pineco', 'bug', 50, 65, 90, 35, 35, 15);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('forretress', 'bug', 'steel', 75, 90, 140, 60, 60, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dunsparce', 'normal', 100, 70, 70, 65, 65, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gligar', 'ground', 'flying', 65, 75, 105, 35, 65, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('steelix', 'steel', 'ground', 75, 85, 200, 55, 65, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('snubbull', 'fairy', 60, 80, 50, 40, 40, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('granbull', 'fairy', 90, 120, 75, 60, 60, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('qwilfish', 'water', 'poison', 65, 95, 75, 55, 55, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('scizor', 'bug', 'steel', 70, 130, 100, 55, 80, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shuckle', 'bug', 'rock', 20, 10, 230, 10, 230, 5);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('heracross', 'bug', 'fighting', 80, 125, 75, 40, 95, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sneasel', 'dark', 'ice', 55, 95, 55, 35, 75, 115);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('teddiursa', 'normal', 60, 80, 50, 50, 50, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ursaring', 'normal', 90, 130, 75, 75, 75, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('slugma', 'fire', 40, 40, 40, 70, 40, 20);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magcargo', 'fire', 'rock', 50, 50, 120, 80, 80, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('swinub', 'ice', 'ground', 50, 50, 40, 30, 30, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('piloswine', 'ice', 'ground', 100, 100, 80, 60, 60, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('corsola', 'water', 'rock', 55, 55, 85, 65, 85, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('remoraid', 'water', 35, 65, 35, 65, 35, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('octillery', 'water', 75, 105, 75, 105, 75, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('delibird', 'ice', 'flying', 45, 55, 45, 65, 45, 75);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mantine', 'water', 'flying', 65, 40, 70, 80, 140, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('skarmory', 'steel', 'flying', 65, 80, 140, 40, 70, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('houndour', 'dark', 'fire', 45, 60, 30, 80, 50, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('houndoom', 'dark', 'fire', 75, 90, 50, 110, 80, 95);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kingdra', 'water', 'dragon', 75, 95, 95, 95, 95, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('phanpy', 'ground', 90, 60, 60, 40, 40, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('donphan', 'ground', 90, 120, 120, 60, 60, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('porygon2', 'normal', 85, 80, 90, 105, 95, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('stantler', 'normal', 73, 95, 62, 85, 65, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('smeargle', 'normal', 55, 20, 35, 20, 45, 75);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tyrogue', 'fighting', 35, 35, 35, 35, 35, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hitmontop', 'fighting', 50, 95, 95, 35, 110, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('smoochum', 'ice', 'psychic', 45, 30, 15, 85, 65, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('elekid', 'electric', 45, 63, 37, 65, 55, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magby', 'fire', 45, 75, 37, 70, 55, 83);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('miltank', 'normal', 95, 80, 105, 40, 70, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('blissey', 'normal', 255, 10, 10, 75, 135, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('raikou', 'electric', 90, 85, 75, 115, 100, 115);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('entei', 'fire', 115, 115, 85, 90, 75, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('suicune', 'water', 100, 75, 115, 90, 115, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('larvitar', 'rock', 'ground', 50, 64, 50, 45, 50, 41);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pupitar', 'rock', 'ground', 70, 84, 70, 65, 70, 51);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tyranitar', 'rock', 'dark', 100, 134, 110, 95, 100, 61);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lugia', 'psychic', 'flying', 106, 90, 130, 90, 154, 110);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ho-oh', 'fire', 'flying', 106, 130, 90, 110, 154, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('celebi', 'psychic', 'grass', 100, 100, 100, 100, 100, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('treecko', 'grass', 40, 45, 35, 65, 55, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('grovyle', 'grass', 50, 65, 45, 85, 65, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sceptile', 'grass', 70, 85, 65, 105, 85, 120);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('torchic', 'fire', 45, 60, 40, 70, 50, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('combusken', 'fire', 'fighting', 60, 85, 60, 85, 60, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('blaziken', 'fire', 'fighting', 80, 120, 70, 110, 70, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mudkip', 'water', 50, 70, 50, 50, 50, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('marshtomp', 'water', 'ground', 70, 85, 70, 60, 70, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('swampert', 'water', 'ground', 100, 110, 90, 85, 90, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('poochyena', 'dark', 35, 55, 35, 30, 30, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mightyena', 'dark', 70, 90, 70, 60, 60, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('zigzagoon', 'normal', 38, 30, 41, 30, 41, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('linoone', 'normal', 78, 70, 61, 50, 61, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wurmple', 'bug', 45, 45, 35, 20, 30, 20);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('silcoon', 'bug', 50, 35, 55, 25, 25, 15);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('beautifly', 'bug', 'flying', 60, 70, 50, 100, 50, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cascoon', 'bug', 50, 35, 55, 25, 25, 15);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dustox', 'bug', 'poison', 60, 50, 70, 50, 90, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lotad', 'water', 'grass', 40, 30, 30, 40, 50, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lombre', 'water', 'grass', 60, 50, 50, 60, 70, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ludicolo', 'water', 'grass', 80, 70, 70, 90, 100, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('seedot', 'grass', 40, 40, 50, 30, 30, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nuzleaf', 'grass', 'dark', 70, 70, 40, 60, 40, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shiftry', 'grass', 'dark', 90, 100, 60, 90, 60, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('taillow', 'normal', 'flying', 40, 55, 30, 30, 30, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('swellow', 'normal', 'flying', 60, 85, 60, 50, 50, 125);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wingull', 'water', 'flying', 40, 30, 30, 55, 30, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pelipper', 'water', 'flying', 60, 50, 100, 85, 70, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ralts', 'psychic', 'fairy', 28, 25, 25, 45, 35, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kirlia', 'psychic', 'fairy', 38, 35, 35, 65, 55, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gardevoir', 'psychic', 'fairy', 68, 65, 65, 125, 115, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('surskit', 'bug', 'water', 40, 30, 32, 50, 52, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('masquerain', 'bug', 'flying', 70, 60, 62, 80, 82, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shroomish', 'grass', 60, 40, 60, 40, 60, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('breloom', 'grass', 'fighting', 60, 130, 80, 60, 60, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('slakoth', 'normal', 60, 60, 60, 35, 35, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('vigoroth', 'normal', 80, 80, 80, 55, 55, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('slaking', 'normal', 150, 160, 100, 95, 65, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nincada', 'bug', 'ground', 31, 45, 90, 30, 30, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ninjask', 'bug', 'flying', 61, 90, 45, 50, 50, 160);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shedinja', 'bug', 'ghost', 1, 90, 45, 30, 30, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('whismur', 'normal', 64, 51, 23, 51, 23, 28);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('loudred', 'normal', 84, 71, 43, 71, 43, 48);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('exploud', 'normal', 104, 91, 63, 91, 73, 68);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('makuhita', 'fighting', 72, 60, 30, 20, 30, 25);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hariyama', 'fighting', 144, 120, 60, 40, 60, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('azurill', 'normal', 'fairy', 50, 20, 40, 20, 40, 20);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('nosepass', 'rock', 30, 45, 135, 45, 90, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('skitty', 'normal', 50, 45, 45, 35, 35, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('delcatty', 'normal', 70, 65, 65, 55, 55, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sableye', 'dark', 'ghost', 50, 75, 75, 65, 65, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mawile', 'steel', 'fairy', 50, 85, 85, 55, 55, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('aron', 'steel', 'rock', 50, 70, 100, 40, 40, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lairon', 'steel', 'rock', 60, 90, 140, 50, 50, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('aggron', 'steel', 'rock', 70, 110, 180, 60, 60, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('meditite', 'fighting', 'psychic', 30, 40, 55, 40, 55, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('medicham', 'fighting', 'psychic', 60, 60, 75, 60, 75, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('electrike', 'electric', 40, 45, 40, 65, 40, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('manectric', 'electric', 70, 75, 60, 105, 60, 105);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('plusle', 'electric', 60, 50, 40, 85, 75, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('minun', 'electric', 60, 40, 50, 75, 85, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('volbeat', 'bug', 65, 73, 55, 47, 75, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('illumise', 'bug', 65, 47, 55, 73, 75, 85);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('roselia', 'grass', 'poison', 50, 60, 45, 100, 80, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gulpin', 'poison', 70, 43, 53, 43, 53, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('swalot', 'poison', 100, 73, 83, 73, 83, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('carvanha', 'water', 'dark', 45, 90, 20, 65, 20, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sharpedo', 'water', 'dark', 70, 120, 40, 95, 40, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wailmer', 'water', 130, 70, 35, 70, 35, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wailord', 'water', 170, 90, 45, 90, 45, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('numel', 'fire', 'ground', 60, 60, 40, 65, 45, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('camerupt', 'fire', 'ground', 70, 100, 70, 105, 75, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('torkoal', 'fire', 70, 85, 140, 85, 70, 20);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('spoink', 'psychic', 60, 25, 35, 70, 80, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('grumpig', 'psychic', 80, 45, 65, 90, 110, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('spinda', 'normal', 60, 60, 60, 60, 60, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('trapinch', 'ground', 45, 100, 45, 45, 45, 10);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('vibrava', 'ground', 'dragon', 50, 70, 50, 50, 50, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('flygon', 'ground', 'dragon', 80, 100, 80, 80, 80, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cacnea', 'grass', 50, 85, 40, 85, 40, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cacturne', 'grass', 'dark', 70, 115, 60, 115, 60, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('swablu', 'normal', 'flying', 45, 40, 60, 40, 75, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('altaria', 'dragon', 'flying', 75, 70, 90, 70, 105, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('zangoose', 'normal', 73, 115, 60, 60, 60, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('seviper', 'poison', 73, 100, 60, 100, 60, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lunatone', 'rock', 'psychic', 70, 55, 65, 95, 85, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('solrock', 'rock', 'psychic', 70, 95, 85, 55, 65, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('barboach', 'water', 'ground', 50, 48, 43, 46, 41, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('whiscash', 'water', 'ground', 110, 78, 73, 76, 71, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('corphish', 'water', 43, 80, 65, 50, 35, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('crawdaunt', 'water', 'dark', 63, 120, 85, 90, 55, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('baltoy', 'ground', 'psychic', 40, 40, 55, 40, 70, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('claydol', 'ground', 'psychic', 60, 70, 105, 70, 120, 75);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lileep', 'rock', 'grass', 66, 41, 77, 61, 87, 23);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cradily', 'rock', 'grass', 86, 81, 97, 81, 107, 43);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('anorith', 'rock', 'bug', 45, 95, 50, 40, 50, 75);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('armaldo', 'rock', 'bug', 75, 125, 100, 70, 80, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('feebas', 'water', 20, 15, 20, 10, 55, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('milotic', 'water', 95, 60, 79, 100, 125, 81);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('castform', 'normal', 70, 70, 70, 70, 70, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kecleon', 'normal', 60, 90, 70, 60, 120, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shuppet', 'ghost', 44, 75, 35, 63, 33, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('banette', 'ghost', 64, 115, 65, 83, 63, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('duskull', 'ghost', 20, 40, 90, 30, 90, 25);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dusclops', 'ghost', 40, 70, 130, 60, 130, 25);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tropius', 'grass', 'flying', 99, 68, 83, 72, 87, 51);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chimecho', 'psychic', 65, 50, 70, 95, 80, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('absol', 'dark', 65, 130, 60, 75, 60, 75);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wynaut', 'psychic', 95, 23, 48, 23, 48, 23);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('snorunt', 'ice', 50, 50, 50, 50, 50, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('glalie', 'ice', 80, 80, 80, 80, 80, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('spheal', 'ice', 'water', 70, 40, 50, 55, 50, 25);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('sealeo', 'ice', 'water', 90, 60, 70, 75, 70, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('walrein', 'ice', 'water', 110, 80, 90, 95, 90, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('clamperl', 'water', 35, 64, 85, 74, 55, 32);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('huntail', 'water', 55, 104, 105, 94, 75, 52);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gorebyss', 'water', 55, 84, 105, 114, 75, 52);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('relicanth', 'water', 'rock', 100, 90, 130, 45, 65, 55);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('luvdisc', 'water', 43, 30, 55, 40, 65, 97);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bagon', 'dragon', 45, 75, 60, 40, 30, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shelgon', 'dragon', 65, 95, 100, 60, 50, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('salamence', 'dragon', 'flying', 95, 135, 80, 110, 80, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('beldum', 'steel', 'psychic', 40, 55, 80, 35, 60, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('metang', 'steel', 'psychic', 60, 75, 100, 55, 80, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('metagross', 'steel', 'psychic', 80, 135, 130, 95, 90, 70);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('regirock', 'rock', 80, 100, 200, 50, 100, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('regice', 'ice', 80, 50, 100, 100, 200, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('registeel', 'steel', 80, 75, 150, 75, 150, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('latias', 'dragon', 'psychic', 80, 80, 90, 110, 130, 110);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('latios', 'dragon', 'psychic', 80, 90, 80, 130, 110, 110);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kyogre', 'water', 100, 100, 90, 150, 140, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('groudon', 'ground', 100, 150, 140, 100, 90, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rayquaza', 'dragon', 'flying', 105, 150, 90, 150, 90, 95);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('jirachi', 'steel', 'psychic', 100, 100, 100, 100, 100, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('deoxys-n', 'psychic', 50, 150, 50, 150, 50, 150);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('deoxys-a', 'psychic', 50, 180, 20, 180, 20, 150);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('deoxys-d', 'psychic', 50, 70, 160, 70, 160, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('deoxys-s', 'psychic', 50, 95, 90, 95, 90, 180);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('turtwig', 'grass', 55, 68, 64, 45, 55, 31);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('grotle', 'grass', 75, 89, 85, 55, 65, 36);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('torterra', 'grass', 'ground', 95, 109, 105, 75, 85, 56);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chimchar', 'fire', 44, 58, 44, 58, 44, 61);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('monferno', 'fire', 'fighting', 64, 78, 52, 78, 52, 81);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('infernape', 'fire', 'fighting', 76, 104, 71, 104, 71, 108);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('piplup', 'water', 53, 51, 53, 61, 56, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('prinplup', 'water', 64, 66, 68, 81, 76, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('empoleon', 'water', 'steel', 84, 86, 88, 111, 101, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('starly', 'normal', 'flying', 40, 55, 30, 30, 30, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('staravia', 'normal', 'flying', 55, 75, 50, 40, 40, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('staraptor', 'normal', 'flying', 85, 120, 70, 50, 60, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bidoof', 'normal', 59, 45, 40, 35, 40, 31);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bibarel', 'normal', 'water', 79, 85, 60, 55, 60, 71);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kricketot', 'bug', 37, 25, 41, 25, 41, 25);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('kricketune', 'bug', 77, 85, 51, 55, 51, 65);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shinx', 'electric', 45, 65, 34, 40, 34, 45);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('luxio', 'electric', 60, 85, 49, 60, 49, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('luxray', 'electric', 80, 120, 79, 95, 79, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('budew', 'grass', 'poison', 40, 30, 35, 50, 70, 55);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('roserade', 'grass', 'poison', 60, 70, 65, 125, 105, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cranidos', 'rock', 67, 125, 40, 30, 30, 58);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rampardos', 'rock', 97, 165, 60, 65, 50, 58);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shieldon', 'rock', 'steel', 30, 42, 118, 42, 88, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bastiodon', 'rock', 'steel', 60, 52, 168, 47, 138, 30);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('burmy', 'bug', 40, 29, 45, 29, 45, 36);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wormadam-p', 'bug', 'grass', 60, 59, 85, 79, 105, 36);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wormadam-s', 'bug', 'ground', 60, 79, 105, 59, 85, 36);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('wormadam-t', 'bug', 'steel', 60, 69, 95, 69, 95, 36);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mothim', 'bug', 'flying', 70, 94, 50, 94, 50, 66);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('combee', 'bug', 'flying', 30, 30, 42, 30, 42, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('vespiquen', 'bug', 'flying', 70, 80, 102, 80, 102, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('pachirisu', 'electric', 60, 45, 70, 45, 90, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('buizel', 'water', 55, 65, 35, 60, 30, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('floatzel', 'water', 85, 105, 55, 85, 50, 115);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cherubi', 'grass', 45, 35, 45, 62, 53, 35);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cherrim', 'grass', 70, 60, 70, 87, 78, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shellos', 'water', 76, 48, 48, 57, 62, 34);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gastrodon', 'water', 'ground', 111, 83, 68, 92, 82, 39);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('ambipom', 'normal', 75, 100, 66, 60, 66, 115);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('drifloon', 'ghost', 'flying', 90, 50, 34, 60, 44, 70);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('drifblim', 'ghost', 'flying', 150, 80, 44, 90, 54, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('buneary', 'normal', 55, 66, 44, 44, 56, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lopunny', 'normal', 65, 76, 84, 54, 96, 105);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mismagius', 'ghost', 60, 60, 60, 105, 105, 105);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('honchkrow', 'dark', 'flying', 100, 125, 52, 105, 52, 71);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('glameow', 'normal', 49, 55, 42, 42, 37, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('purugly', 'normal', 71, 82, 64, 64, 59, 112);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chingling', 'psychic', 45, 30, 50, 65, 50, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('stunky', 'poison', 'dark', 63, 63, 47, 41, 41, 74);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('skuntank', 'poison', 'dark', 103, 93, 67, 71, 61, 84);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bronzor', 'steel', 'psychic', 57, 24, 86, 24, 86, 23);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bronzong', 'steel', 'psychic', 67, 89, 116, 79, 116, 33);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('bonsly', 'rock', 50, 80, 95, 10, 45, 10);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mime jr.', 'psychic', 'fairy', 20, 25, 45, 70, 90, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('happiny', 'normal', 100, 5, 5, 15, 65, 30);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('chatot', 'normal', 'flying', 76, 65, 45, 92, 42, 91);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('spiritomb', 'ghost', 'dark', 50, 92, 108, 92, 108, 35);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gible', 'dragon', 'ground', 58, 70, 45, 40, 45, 42);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gabite', 'dragon', 'ground', 68, 90, 65, 50, 55, 82);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('garchomp', 'dragon', 'ground', 108, 130, 95, 80, 85, 102);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('munchlax', 'normal', 135, 85, 40, 40, 85, 5);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('riolu', 'fighting', 40, 70, 40, 35, 40, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lucario', 'fighting', 'steel', 70, 110, 70, 115, 70, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hippopotas', 'ground', 68, 72, 78, 38, 42, 32);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('hippowdon', 'ground', 108, 112, 118, 68, 72, 47);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('skorupi', 'poison', 'bug', 40, 50, 90, 30, 55, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('drapion', 'poison', 'dark', 70, 90, 110, 60, 75, 95);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('croagunk', 'poison', 'fighting', 48, 61, 40, 61, 40, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('toxicroak', 'poison', 'fighting', 83, 106, 65, 86, 65, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('carnivine', 'grass', 74, 100, 72, 90, 72, 46);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('finneon', 'water', 49, 49, 56, 49, 61, 66);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lumineon', 'water', 69, 69, 76, 69, 86, 91);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mantyke', 'water', 'flying', 45, 20, 50, 60, 120, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('snover', 'grass', 'ice', 60, 62, 50, 62, 60, 40);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('abomasnow', 'grass', 'ice', 90, 92, 75, 92, 85, 60);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('weavile', 'dark', 'ice', 70, 120, 65, 45, 85, 125);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magnezone', 'electric', 'steel', 70, 70, 115, 130, 90, 60);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('lickilicky', 'normal', 110, 85, 95, 80, 95, 50);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rhyperior', 'ground', 'rock', 115, 140, 130, 55, 55, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('tangrowth', 'grass', 100, 100, 125, 110, 50, 50);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('electivire', 'electric', 75, 123, 67, 95, 85, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('magmortar', 'fire', 75, 95, 67, 125, 95, 83);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('togekiss', 'fairy', 'flying', 85, 50, 95, 120, 115, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('leafeon', 'grass', 65, 110, 130, 60, 65, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('glaceon', 'ice', 65, 60, 110, 130, 95, 65);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gliscor', 'ground', 'flying', 75, 95, 125, 45, 75, 95);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mamoswine', 'ice', 'ground', 110, 130, 80, 70, 60, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('porygon-z', 'normal', 85, 80, 70, 135, 75, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('gallade', 'psychic', 'fighting', 68, 125, 65, 65, 115, 80);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('probopass', 'rock', 'steel', 60, 55, 145, 75, 150, 40);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dusknoir', 'ghost', 45, 100, 135, 65, 135, 45);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('froslass', 'ice', 'ghost', 70, 80, 70, 80, 70, 110);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rotom', 'electric', 'ghost', 50, 50, 77, 95, 77, 91);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rotom-h', 'electric', 'fire', 50, 65, 107, 105, 107, 86);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rotom-w', 'electric', 'water', 50, 65, 107, 105, 107, 86);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rotom-f', 'electric', 'ice', 50, 65, 107, 105, 107, 86);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rotom-s', 'electric', 'flying', 50, 65, 107, 105, 107, 86);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('rotom-c', 'electric', 'grass', 50, 65, 107, 105, 107, 86);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('uxie', 'psychic', 75, 75, 130, 75, 130, 95);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('mesprit', 'psychic', 80, 105, 105, 105, 105, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('azelf', 'psychic', 75, 125, 70, 125, 70, 115);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('dialga', 'steel', 'dragon', 100, 120, 120, 150, 100, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('palkia', 'water', 'dragon', 90, 120, 100, 150, 120, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('heatran', 'fire', 'steel', 91, 90, 106, 130, 106, 77);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('regigigas', 'normal', 110, 160, 110, 80, 110, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('giratina-a', 'ghost', 'dragon', 150, 100, 120, 100, 120, 90);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('giratina-o', 'ghost', 'dragon', 150, 120, 100, 120, 100, 90);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('cresselia', 'psychic', 120, 70, 120, 75, 130, 85);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('phione', 'water', 80, 80, 80, 80, 80, 80);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('manaphy', 'water', 100, 100, 100, 100, 100, 100);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('darkrai', 'dark', 70, 90, 90, 135, 90, 125);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shaymin-l', 'grass', 100, 100, 100, 100, 100, 100);
INSERT INTO pokedex (pkmn_name, type_1, type_2, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('shaymin-s', 'grass', 'flying', 100, 103, 75, 120, 75, 127);
INSERT INTO pokedex (pkmn_name, type_1, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed) VALUES ('arceus', 'normal', 120, 120, 120, 120, 120, 120);

INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('adamant', 1.1, 0.9, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('bashful', 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('bold', 0.9, 1.0, 1.1, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('brave', 1.1, 1.0, 1.0, 1.0, 0.9);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('calm', 0.9, 1.0, 1.0, 1.1, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('careful', 1.0, 0.9, 1.0, 1.1, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('docile', 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('gentle', 1.0, 1.0, 0.9, 1.1, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('hardy', 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('hasty', 1.0, 1.0, 0.9, 1.0, 1.1);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('impish', 1.0, 0.9, 1.1, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('jolly', 1.0, 0.9, 1.0, 1.0, 1.1);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('lax', 1.0, 1.0, 1.1, 0.9, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('lonely', 1.1, 1.0, 0.9, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('mild', 1.0, 1.1, 0.9, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('modest', 0.9, 1.1, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('naive', 1.0, 1.0, 1.0, 0.9, 1.1);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('naughty', 1.1, 1.0, 1.0, 0.9, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('quiet', 1.0, 1.1, 1.0, 1.0, 0.9);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('quirky', 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('rash', 1.0, 1.1, 1.0, 0.9, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('relaxed', 1.0, 1.0, 1.1, 1.0, 0.9);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('sassy', 1.0, 1.0, 1.0, 1.1, 0.9);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('serious', 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO nature (nature_name, attack_mult, special_attack_mult, defense_mult, special_defense_mult, speed_mult) VALUES ('timid', 0.9, 1.0, 1.0, 1.0, 1.1);