DELIMITER !

CREATE FUNCTION is_hacked (pkmn VARCHAR(30), hp INT, atk INT, spa INT, def INT,
                           spd INT, spe INT, pkmn_nature VARCHAR(10), lvl INT)
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
base_spd, base_spe FROM pokedex WHERE pkmn_name = pkmn;

SELECT attack_mult, special_attack_mult, defense_mult, special_defense_mult,
speed_mult INTO atk_mult, spa_mult, def_mult, spd_mult, spe_mult FROM nature
WHERE nature_name = pkmn_nature;

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