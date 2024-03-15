DROP FUNCTION IF EXISTS is_pkmn_hacked;
DROP FUNCTION IF EXISTS detect_weak;
DROP PROCEDURE IF EXISTS sp_update_hacked_flag;
DROP PROCEDURE IF EXISTS sp_create_user_boxes;
DROP PROCEDURE IF EXISTS sp_update_box_count;
DROP PROCEDURE IF EXISTS sp_update_box_count_move;
DROP TRIGGER IF EXISTS trg_create_boxes;
DROP TRIGGER IF EXISTS trg_perform_hack_check;
DROP TRIGGER IF EXISTS trg_update_box_counts;
DROP TRIGGER IF EXISTS trg_update_box_counts_move;

DELIMITER !

CREATE FUNCTION is_pkmn_hacked (pid INT, hp INT, atk INT, spa INT, def INT,
                           spd INT, spe INT, lvl INT)
                           RETURNS TINYINT DETERMINISTIC
BEGIN

DECLARE base_hp INT;
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
DECLARE evs DECIMAL (6, 0);

SET evs = 508;

SELECT base_hp, base_attack, base_special_attack, base_defense, 
base_special_defense, base_speed INTO base_hp, base_atk, base_spa, base_def,
base_spd, base_spe FROM pokedex 
WHERE pkmn_name = (SELECT pkmn_name FROM has_species WHERE pkmn_id = pid);

SELECT attack_mult, special_attack_mult, defense_mult, special_defense_mult,
speed_mult INTO atk_mult, spa_mult, def_mult, spd_mult, spe_mult FROM nature
WHERE nature_name = (SELECT nature_name FROM has_nature WHERE pkmn_id = pid);

IF hp BETWEEN FLOOR(2 * base_hp * lvl / 100) + lvl + 10 
AND FLOOR((2 * base_hp + 94) * lvl / 100) + lvl + 10
    THEN IF hp - (FLOOR((2 * base_hp + 31) * lvl / 100) + lvl + 10) > 0
        THEN SET evs = evs - 
        ((4 * (100 * hp - 100 * lvl - 1000) / lvl) - 8 * base_hp - 124);
    END IF;
ELSE
    RETURN 0;
END IF;

IF atk BETWEEN FLOOR((FLOOR(2 * base_atk * lvl / 100) + 5) * atk_mult)
AND FLOOR((FLOOR((2 * base_atk + 94) * lvl / 100) + 5) * atk_mult)
    THEN 
    IF atk - FLOOR((FLOOR((2 * base_atk + 31) * lvl / 100) + 5) * atk_mult) > 0
        THEN SET evs = evs - 
        (((400 * atk - 2000 * atk_mult) / (lvl * atk_mult))
        - 8 * base_atk - 132);
    END IF;
ELSE
    RETURN 0;
END IF;

IF spa BETWEEN FLOOR((FLOOR(2 * base_spa * lvl / 100) + 5) * spa_mult)
AND FLOOR((FLOOR((2 * base_spa + 94) * lvl / 100) + 5) * spa_mult)
    THEN 
    IF spa - FLOOR((FLOOR((2 * base_spa + 31) * lvl / 100) + 5) * spa_mult) > 0
        THEN SET evs = evs - 
        (((400 * spa - 2000 * spa_mult) / (lvl * spa_mult))
        - 8 * base_spa - 132);
    END IF;
ELSE
    RETURN 0;
END IF;

IF def BETWEEN FLOOR((FLOOR(2 * base_def * lvl / 100) + 5) * def_mult)
AND FLOOR((FLOOR((2 * base_def + 94) * lvl / 100) + 5) * def_mult)
    THEN 
    IF def - FLOOR((FLOOR((2 * base_def + 31) * lvl / 100) + 5) * def_mult) > 0
        THEN SET evs = evs - 
        (((400 * def - 2000 * def_mult) / (lvl * def_mult))
        - 8 * base_def - 132);
    END IF;
ELSE
    RETURN 0;
END IF;

IF spd BETWEEN FLOOR((FLOOR(2 * base_spd * lvl / 100) + 5) * spd_mult)
AND FLOOR((FLOOR((2 * base_spd + 94) * lvl / 100) + 5) * spd_mult)
    THEN 
    IF spd - FLOOR((FLOOR((2 * base_def + 31) * lvl / 100) + 5) * spd_mult) > 0
        THEN SET evs = evs - 
        (((400 * spd - 2000 * spd_mult) / (lvl * spd_mult))
        - 8 * base_spd - 132);
    END IF;
ELSE
    RETURN 0;
END IF;

IF spe BETWEEN FLOOR((FLOOR(2 * base_spe * lvl / 100) + 5) * spe_mult)
AND FLOOR((FLOOR((2 * base_spe + 94) * lvl / 100) + 5) * spe_mult)
    THEN 
    IF spe - FLOOR((FLOOR((2 * base_spe + 31) * lvl / 100) + 5) * spe_mult) > 0
        THEN SET evs = evs - 
        (((400 * spe - 2000 * spe_mult) / (lvl * spe_mult))
        - 8 * base_spe - 132);
    END IF;
ELSE
    RETURN 0;
END IF;

IF evs < 0
    THEN RETURN 0;
ELSE
    RETURN 1;
END IF;

END !

DELIMITER ;

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

DECLARE hacked_flag TINYINT;
SELECT 
is_pkmn_hacked(pid, hp, attack, special_attack, defense, special_defense, 
               speed, lvl)
INTO hacked_flag;
INSERT INTO hack_checks VALUES (pid, hacked_flag);

END !

CREATE TRIGGER trg_perform_hack_check AFTER INSERT
    ON collected FOR EACH ROW
BEGIN

CALL sp_update_hacked_flag(NEW.pkmn_id, NEW.hp, NEW.attack, NEW.special_attack,
                           NEW.defense, NEW.special_defense, NEW.speed, 
                           NEW.lvl);

END !

DELIMITER ;

DELIMITER !

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

CREATE TRIGGER trg_create_boxes AFTER INSERT
    ON users FOR EACH ROW
BEGIN

CALL sp_create_user_boxes(NEW.user_id);

END !

DELIMITER ;

DELIMITER !

CREATE PROCEDURE sp_update_box_count (
    updated_box_id INT
)
BEGIN

UPDATE boxes SET num_pokemon = num_pokemon + 1 WHERE box_id = updated_box_id;

END !

CREATE TRIGGER trg_update_box_counts AFTER INSERT
    ON has_box FOR EACH ROW
BEGIN

CALL sp_update_box_count(NEW.box_id);

END !

CREATE PROCEDURE sp_update_box_count_move (
    prev_box_id INT,
    new_box_id INT
)
BEGIN

UPDATE boxes SET num_pokemon = num_pokemon - 1 WHERE box_id = prev_box_id;
UPDATE boxes SET num_pokemon = num_pokemon + 1 WHERE box_id = new_box_id;

END !

CREATE TRIGGER trg_update_box_counts_move AFTER UPDATE
    ON has_box FOR EACH ROW
BEGIN

CALL sp_update_box_count_move(OLD.box_id, NEW.box_id);

END !

DELIMITER ;
