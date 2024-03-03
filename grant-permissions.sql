-- WIP: STILL WORKING ON DETERMINING EXACT PRIVILEGES FOR CLIENTS

-- create users with passwords
CREATE USER 'appadmin'@'localhost' IDENTIFIED BY 'adminpw';
CREATE USER 'appclient'@'localhost' IDENTIFIED BY 'clientpw';

-- admins can access everything and do anything to everything
GRANT ALL PRIVILEGES ON *.* TO 'appadmin'@'localhost';

-- clients can access and modify the user, boxes, and collected tables, but 
-- only have SELECT privileges for everything else
GRANT ALL PRIVILEGES ON user.*, boxes.*, collected.* 
TO 'appclient'@'localhost';
GRANT SELECT ON type_weaknesses.*, nature.*, pokedex.*
TO 'appclient'@'localhost';

-- Flush the GRANT commands to update the privileges
FLUSH PRIVILEGES;