-- WIP: STILL WORKING ON DETERMINING EXACT PRIVILEGES FOR CLIENTS

-- create users with passwords
CREATE USER 'appadmin'@'localhost' IDENTIFIED BY 'AdminPW2024!';
CREATE USER 'appclient'@'localhost' IDENTIFIED BY 'ClientPW2024!';

-- admins can access everything and do anything to everything
GRANT ALL PRIVILEGES ON *.* TO 'appadmin'@'localhost';

-- clients can access and modify the user, boxes, and collected tables, but 
-- only have SELECT privileges for everything else
GRANT ALL PRIVILEGES ON users.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON boxes.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON collected.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON hack_checks.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON has_box.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON has_nature.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON has_species.* TO 'appclient'@'localhost';
GRANT ALL PRIVILEGES ON box_owner.* TO 'appclient'@'localhost';

GRANT SELECT ON type_weaknesses.* TO 'appclient'@'localhost';
GRANT SELECT ON nature.* TO 'appclient'@'localhost';
GRANT SELECT ON pokedex.* TO 'appclient'@'localhost';

-- Flush the GRANT commands to update the privileges
FLUSH PRIVILEGES;