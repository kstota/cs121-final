DROP TRIGGER IF EXISTS trg_create_boxes;
DROP TRIGGER IF EXISTS trg_perform_hack_check;
DROP TRIGGER IF EXISTS trg_update_box_counts_add;
DROP TRIGGER IF EXISTS trg_update_box_counts_del;
DROP TRIGGER IF EXISTS trg_update_box_counts_move;
DROP PROCEDURE IF EXISTS sp_update_hacked_flag;
DROP PROCEDURE IF EXISTS sp_create_user_boxes;
DROP PROCEDURE IF EXISTS sp_update_box_count_add;
DROP PROCEDURE IF EXISTS sp_update_box_count_del;
DROP PROCEDURE IF EXISTS sp_update_box_count_move;
DROP PROCEDURE IF EXISTS sp_add_to_box;
DROP PROCEDURE IF EXISTS sp_insert_into_pokedex;
DROP FUNCTION IF EXISTS is_pkmn_hacked;
DROP FUNCTION IF EXISTS detect_weak;

DELIMITER !

-- TODO: comment
CREATE FUNCTION is_pkmn_hacked (pid INT, hp INT, atk INT, spa INT, def INT,
                           spd INT, spe INT, lvl INT, evs DECIMAL(10, 6))
                           RETURNS TINYINT DETERMINISTIC
BEGIN

DECLARE base_h INT;
DECLARE base_atk INT;
DECLARE base_spa INT;
DECLARE base_def INT;
DECLARE base_spd INT;
DECLARE base_spe INT;
DECLARE atk_mult DECIMAL(2, 1);
DECLARE spa_mult DECIMAL(2, 1);
DECLARE def_mult DECIMAL(2, 1);
DECLARE spd_mult DECIMAL(2, 1);
DECLARE spe_mult DECIMAL(2, 1);

SELECT base_hp, base_attack, base_special_attack, base_defense, 
base_special_defense, base_speed INTO base_h, base_atk, base_spa, base_def,
base_spd, base_spe FROM pokedex 
WHERE pkmn_name = (SELECT pkmn_name FROM has_species WHERE pkmn_id = pid);

SELECT attack_mult, special_attack_mult, defense_mult, special_defense_mult,
speed_mult INTO atk_mult, spa_mult, def_mult, spd_mult, spe_mult FROM nature
WHERE nature_name = (SELECT nature_name FROM has_nature WHERE pkmn_id = pid);

IF hp BETWEEN FLOOR(2 * base_h * lvl / 100) + lvl + 10 
AND FLOOR((2 * base_h + 94) * lvl / 100) + lvl + 10
    THEN IF hp - (FLOOR((2 * base_h + 31) * lvl / 100) + lvl + 10) > 0
        THEN SET evs = evs - 
        (CEILING(4 * (100 * hp - 100 * lvl - 1000) / lvl) - 8 * base_h - 124);
        IF MOD((CEILING(4 * (100 * hp - 100 * lvl - 1000) / lvl) 
        - 8 * base_h - 124), 4) <> 0
            THEN SET evs = evs -
            (4 - MOD((CEILING(4 * (100 * hp - 100 * lvl - 1000) / lvl) 
            - 8 * base_h - 124), 4));
        END IF;
    END IF;
ELSE
    RETURN 1;
END IF;

IF atk BETWEEN FLOOR((FLOOR(2 * base_atk * lvl / 100) + 5) * atk_mult)
AND FLOOR((FLOOR((2 * base_atk + 94) * lvl / 100) + 5) * atk_mult)
    THEN
    IF atk - FLOOR((FLOOR((2 * base_atk + 31) * lvl / 100) + 5) * atk_mult) > 0
        THEN SET evs = evs - 
        (CEILING((400 * atk - 2000 * atk_mult) / (lvl * atk_mult))
        - 8 * base_atk - 124);
        IF MOD((CEILING((400 * atk - 2000 * atk_mult) / (lvl * atk_mult))
        - 8 * base_atk - 124), 4) <> 0
            THEN SET evs = evs - 
            (4 - MOD((CEILING((400 * atk - 2000 * atk_mult) / (lvl * atk_mult))
            - 8 * base_atk - 124), 4));
        END IF;
    END IF;
ELSE
    RETURN 1;
END IF;

IF spa BETWEEN FLOOR((FLOOR(2 * base_spa * lvl / 100) + 5) * spa_mult)
AND FLOOR((FLOOR((2 * base_spa + 94) * lvl / 100) + 5) * spa_mult)
    THEN 
    IF spa - FLOOR((FLOOR((2 * base_spa + 31) * lvl / 100) + 5) * spa_mult) > 0
        THEN SET evs = evs - 
        (CEILING((400 * spa - 2000 * spa_mult) / (lvl * spa_mult))
        - 8 * base_spa - 124);
        IF MOD((CEILING((400 * spa - 2000 * spa_mult) / (lvl * spa_mult))
        - 8 * base_spa - 124), 4) <> 0
            THEN SET evs = evs - 
            (4 - MOD((CEILING((400 * spa - 2000 * spa_mult) / (lvl * spa_mult))
            - 8 * base_spa - 124), 4));
        END IF;
    END IF;
ELSE
    RETURN 1;
END IF;

IF def BETWEEN FLOOR((FLOOR(2 * base_def * lvl / 100) + 5) * def_mult)
AND FLOOR((FLOOR((2 * base_def + 94) * lvl / 100) + 5) * def_mult)
    THEN 
    IF def - FLOOR((FLOOR((2 * base_def + 31) * lvl / 100) + 5) * def_mult) > 0
        THEN SET evs = evs - 
        (CEILING((400 * def - 2000 * def_mult) / (lvl * def_mult))
        - 8 * base_def - 124);
        IF MOD((CEILING((400 * def - 2000 * def_mult) / (lvl * def_mult))
        - 8 * base_def - 124), 4) <> 0
            THEN SET evs = evs - 
            (4 - MOD((CEILING((400 * def - 2000 * def_mult) / (lvl * def_mult))
            - 8 * base_def - 124), 4));
        END IF;
    END IF;
ELSE
    RETURN 1;
END IF;

IF spd BETWEEN FLOOR((FLOOR(2 * base_spd * lvl / 100) + 5) * spd_mult)
AND FLOOR((FLOOR((2 * base_spd + 94) * lvl / 100) + 5) * spd_mult)
    THEN 
    IF spd - FLOOR((FLOOR((2 * base_spd + 31) * lvl / 100) + 5) * spd_mult) > 0
        THEN SET evs = evs - 
        (CEILING((400 * spd - 2000 * spd_mult) / (lvl * spd_mult))
        - 8 * base_spd - 124);
        IF MOD((CEILING((400 * spd - 2000 * spd_mult) / (lvl * spd_mult))
        - 8 * base_spd - 124), 4) <> 0
            THEN SET evs = evs - 
            (4 - MOD((CEILING((400 * spd - 2000 * spd_mult) / (lvl * spd_mult))
            - 8 * base_spd - 124), 4));
        END IF;
    END IF;
ELSE
    RETURN 1;
END IF;

IF spe BETWEEN FLOOR((FLOOR(2 * base_spe * lvl / 100) + 5) * spe_mult)
AND FLOOR((FLOOR((2 * base_spe + 94) * lvl / 100) + 5) * spe_mult)
    THEN 
    IF spe - FLOOR((FLOOR((2 * base_spe + 31) * lvl / 100) + 5) * spe_mult) > 0
        THEN SET evs = evs - 
        (CEILING((400 * spe - 2000 * spe_mult) / (lvl * spe_mult))
        - 8 * base_spe - 124);
        IF MOD((CEILING((400 * spe - 2000 * spe_mult) / (lvl * spe_mult))
        - 8 * base_spe - 124), 4) <> 0
            THEN SET evs = evs - 
            (4 - MOD((CEILING((400 * spe - 2000 * spe_mult) / (lvl * spe_mult))
            - 8 * base_spe - 124), 4));
        END IF;
    END IF;
ELSE
    RETURN 1;
END IF;

IF evs < 0
    THEN RETURN 1;
ELSE
    RETURN 0;
END IF;

END !

DELIMITER ;

-- TODO: comment
DELIMITER !

CREATE FUNCTION detect_weak (pkmn VARCHAR(30), attack_t VARCHAR(10))
RETURNS TINYINT DETERMINISTIC
BEGIN

DECLARE t1 VARCHAR(10);
DECLARE t2 VARCHAR(10);
DECLARE mult_t1 DECIMAL(3, 2);
DECLARE mult_t2 DECIMAL(3, 2);

SELECT type_1, type_2 INTO t1, t2 FROM pokedex WHERE pkmn_name = pkmn;

SELECT multiplier INTO mult_t1 FROM type_weaknesses
WHERE defending_type = t1 AND attack_type = attack_t;

IF t2 IS NOT NULL
    THEN SELECT multiplier INTO mult_t2 FROM type_weaknesses
    WHERE defending_type = t2 AND attack_type = attack_t;
ELSE
    SET mult_t2 = 1;
END IF;

IF mult_t1 * mult_t2 > 1
    THEN RETURN 1;
ELSE
    RETURN 0;
END IF;

END !

DELIMITER ;

DELIMITER !

-- TODO: comment
CREATE PROCEDURE sp_update_hacked_flag (
    pid INT, 
    hp INT,
    attack INT,
    special_attack INT,
    defense INT,
    special_defense INT,
    speed INT,
    lvl INT
)
BEGIN

DECLARE hacked_flag INT;

SELECT 
is_pkmn_hacked(pid, hp, attack, special_attack, defense, special_defense, 
               speed, lvl, 508)
INTO hacked_flag;
INSERT INTO hack_checks VALUES (pid, hacked_flag);

END !

-- TODO: comment
CREATE TRIGGER trg_perform_hack_check AFTER INSERT
    ON has_nature FOR EACH ROW
BEGIN

DECLARE new_hp INT;
DECLARE new_atk INT;
DECLARE new_spa INT;
DECLARE new_def INT;
DECLARE new_spd INT;
DECLARE new_spe INT;
DECLARE new_lvl INT;

SELECT hp, attack, special_attack, defense, special_defense, speed, lvl 
INTO new_hp, new_atk, new_spa, new_def, new_spd, new_spe, new_lvl
FROM collected WHERE collected.pkmn_id = NEW.pkmn_id;

CALL sp_update_hacked_flag(NEW.pkmn_id, new_hp, new_atk, new_spa,
                           new_def, new_spd, new_spe, new_lvl);

END !

DELIMITER ;

DELIMITER !

-- TODO: comment
CREATE PROCEDURE sp_create_user_boxes (
    new_user_id VARCHAR(10)
)
BEGIN

DECLARE i INT DEFAULT 0;

WHILE i < 16 DO
    INSERT INTO boxes (num_pokemon) VALUES (0);
    INSERT INTO box_owner (box_id, user_id) 
    SELECT LAST_INSERT_ID(), new_user_id;
    SET i = i + 1;
END WHILE;

END !

-- TODO: comment
CREATE TRIGGER trg_create_boxes AFTER INSERT
    ON users FOR EACH ROW
BEGIN

CALL sp_create_user_boxes(NEW.user_id);

END !

DELIMITER ;

DELIMITER !

-- TODO: comment
CREATE PROCEDURE sp_update_box_count_add (
    updated_box_id INT
)
BEGIN

UPDATE boxes SET num_pokemon = num_pokemon + 1 WHERE box_id = updated_box_id;

END !

-- TODO: COMMENT
CREATE TRIGGER trg_update_box_counts_add AFTER INSERT
    ON has_box FOR EACH ROW
BEGIN

CALL sp_update_box_count(NEW.box_id);

END !

-- TODO: comment
CREATE PROCEDURE sp_update_box_count_del (
    updated_box_id INT
)
BEGIN

UPDATE boxes SET num_pokemon = num_pokemon - 1 WHERE box_id = updated_box_id;

END !

-- TODO: COMMENT
CREATE TRIGGER trg_update_box_counts_del AFTER DELETE
    ON has_box FOR EACH ROW
BEGIN

CALL sp_update_box_count(OLD.box_id);

END !

-- TODO: comment
CREATE PROCEDURE sp_update_box_count_move (
    prev_box_id INT,
    new_box_id INT
)
BEGIN

UPDATE boxes SET num_pokemon = num_pokemon - 1 WHERE box_id = prev_box_id;
UPDATE boxes SET num_pokemon = num_pokemon + 1 WHERE box_id = new_box_id;

END !

-- TODO: comment
CREATE TRIGGER trg_update_box_counts_move AFTER UPDATE
    ON has_box FOR EACH ROW
BEGIN

CALL sp_update_box_count_move(OLD.box_id, NEW.box_id);

END !

DELIMITER ;

DELIMITER !
-- TODO: comment
CREATE PROCEDURE sp_insert_into_pokedex (
    p_name VARCHAR(30),
    dex_number INT,
    t1 VARCHAR(10),
    t2 VARCHAR(10),
    b_hp INT,
    b_attack INT,
    b_special_attack INT,
    b_defense INT,
    b_special_defense INT,
    b_speed INT
)
BEGIN

INSERT INTO pokedex 
(pkmn_name, pokedex_number, type_1, type_2, base_hp, base_attack, 
base_special_attack, base_defense, base_special_defense, base_speed) VALUES
(p_name, dex_number, t1, t2, b_hp, b_attack, b_special_attack, b_defense,
b_special_defense, b_speed);

END !

-- TODO: comment
CREATE PROCEDURE sp_add_to_box (
    user VARCHAR(10),
    p_name VARCHAR(30),
    nickname VARCHAR(30),
    bn INT,
    h INT, 
    atk INT,
    spa INT,
    def INT,
    spd INT, 
    spe INT, 
    lvl INT,
    nature VARCHAR(10)
)
BEGIN

INSERT INTO collected 
(pkmn_nickname, hp, attack, special_attack, defense, special_defense, speed, 
lvl) VALUES (nickname, h, atk, spa, def, spd, spe, lvl);

INSERT INTO has_box (pkmn_id, box_id) VALUES 
(LAST_INSERT_ID(), (SELECT box_id FROM box_owner 
WHERE user_id = user AND (MOD(box_id - 1, 16) + 1) = bn));

INSERT INTO has_species (pkmn_id, pkmn_name) VALUES (LAST_INSERT_ID(), p_name);

INSERT INTO has_nature (pkmn_id, nature_name) VALUES 
(LAST_INSERT_ID(), nature);

END !

DELIMITER ;