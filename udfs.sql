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
DECLARE evs DECIMAL (3, 0);

SET evs = 508;

SELECT base_hp, base_attack, base_special_attack, base_defense, 
base_special_defense, base_speed INTO base_hp, base_atk, base_spa, base_def,
base_spd, base_spe FROM base_stats WHERE pkmn_name = pkmn;

SELECT attack_mult, special_attack_mult, defense_mult, special_defense_mult,
speed_mult INTO atk_mult, spa_mult, def_mult, spd_mult, spe_mult FROM nature
WHERE nature_name = pkmn_nature;

IF hp NOT BETWEEN FLOOR(2 * base_hp * lvl / 100) + lvl + 10 
AND FLOOR((2 * base_hp + 94) * lvl / 100) + lvl + 10
    THEN RETURN 0;
ELSEIF atk NOT BETWEEN FLOOR((FLOOR(2 * base_atk * lvl / 100) + 5) * atk_mult)
AND FLOOR((FLOOR((2 * base_atk + 94) * lvl / 100) + 5) * atk_mult)
    THEN RETURN 0;
ELSEIF spa NOT BETWEEN FLOOR((FLOOR(2 * base_spa * lvl / 100) + 5) * spa_mult)
AND FLOOR((FLOOR((2 * base_spa + 94) * lvl / 100) + 5) * spa_mult)
    THEN RETURN 0;
ELSEIF def NOT BETWEEN FLOOR((FLOOR(2 * base_def * lvl / 100) + 5) * def_mult)
AND FLOOR((FLOOR((2 * base_def + 94) * lvl / 100) + 5) * def_mult)
    THEN RETURN 0;
ELSEIF spd NOT BETWEEN FLOOR((FLOOR(2 * base_spd * lvl / 100) + 5) * spd_mult)
AND FLOOR((FLOOR((2 * base_spd + 94) * lvl / 100) + 5) * spd_mult)
    THEN RETURN 0;
ELSEIF spe NOT BETWEEN FLOOR((FLOOR(2 * base_spe * lvl / 100) + 5) * spe_mult)
AND FLOOR((FLOOR((2 * base_spe + 94) * lvl / 100) + 5) * spe_mult)
    THEN RETURN 0;
ELSE
    RETURN 1;
END IF;

END !

DELIMITER ;