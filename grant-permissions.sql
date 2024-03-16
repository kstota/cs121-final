-- create users with passwords
CREATE USER 'pssadmin'@'localhost' IDENTIFIED BY 'AdminPW2024!';
CREATE USER 'pssclient'@'localhost' IDENTIFIED BY 'ClientPW2024!';

-- admins can access everything and do anything to everything
GRANT ALL PRIVILEGES ON *.* TO 'pssadmin'@'localhost';

-- clients can access and modify the user, boxes, and collected tables (as well
-- as all other relationship-set tables related to these entity-sets), but 
-- only have SELECT privileges for everything else
GRANT ALL PRIVILEGES ON final_db_v5.users TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.boxes TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.collected TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.hack_checks TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.has_box TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.has_nature TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.has_species TO 'pssclient'@'localhost';
GRANT ALL PRIVILEGES ON final_db_v5.box_owner TO 'pssclient'@'localhost';
GRANT SELECT ON final_db_v5.type_weaknesses TO 'pssclient'@'localhost';
GRANT SELECT ON final_db_v5.nature TO 'pssclient'@'localhost';
GRANT SELECT ON final_db_v5.pokedex TO 'pssclient'@'localhost';

-- clients also need access to all of the UDFs/procedures that enable the
-- Pokemon Storage System to function as intended
GRANT EXECUTE ON FUNCTION make_salt TO 'pssclient'@'localhost';
GRANT EXECUTE ON FUNCTION authenticate TO 'pssclient'@'localhost';
GRANT EXECUTE ON FUNCTION is_pkmn_hacked TO 'pssclient'@'localhost';
GRANT EXECUTE ON FUNCTION detect_weak TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_add_client TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_change_password TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_update_hacked_flag TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_create_user_boxes TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_update_box_count TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_update_box_count_move TO 'pssclient'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_add_to_box TO 'pssclient'@'localhost';

-- Flush the GRANT commands to update the privileges
FLUSH PRIVILEGES;