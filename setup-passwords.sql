-- Password Management 

-- This function generates a specified number of characters for 
-- using as a salt in passwords.
DELIMITER !

DROP FUNCTION IF EXISTS make_salt;
CREATE FUNCTION make_salt(num_chars INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(20) DEFAULT '';

    -- Don't want to generate more than 20 characters of salt.
    SET num_chars = LEAST(20, num_chars);

    -- Generate the salt!  Characters used are ASCII code 32 (space)
    -- through 126 ('z').
    WHILE num_chars > 0 DO
        SET salt = CONCAT(salt, CHAR(32 + FLOOR(RAND() * 95)));
        SET num_chars = num_chars - 1;
    END WHILE;

    RETURN salt;
END !

DELIMITER ;

-- Adds a new user to the users table, using the specified password (max
-- of 20 characters). Salts the password with a newly-generated salt value,
-- and then the salt and hash values are both stored in the table.
DELIMITER !

DROP PROCEDURE IF EXISTS sp_add_client;
CREATE PROCEDURE sp_add_client(new_username VARCHAR(20), password VARCHAR(20))
BEGIN
  DECLARE salt CHAR(8);
  DECLARE password_hash BINARY(64);

  SELECT make_salt(8) INTO salt;
  SELECT SHA2(CONCAT(salt, password), 256) INTO password_hash;
  INSERT INTO users (user_id, salt, password_hash, is_admin) 
  VALUES (new_username, salt, password_hash, 0);
END !

DROP PROCEDURE IF EXISTS sp_add_admin;
CREATE PROCEDURE sp_add_admin(new_username VARCHAR(20), password VARCHAR(20))
BEGIN
  DECLARE salt CHAR(8);
  DECLARE password_hash BINARY(64);

  SELECT make_salt(8) INTO salt;
  SELECT SHA2(CONCAT(salt, password), 256) INTO password_hash;
  INSERT INTO users (user_id, salt, password_hash, is_admin) 
  VALUES (new_username, salt, password_hash, 1);
END !

DELIMITER ;

-- Authenticates the specified username and password against the data
-- in the users table. Returns 1 if the user appears in the table, and the
-- specified password hashes to the value for the user. Otherwise returns 0.
DELIMITER !

DROP FUNCTION IF EXISTS authenticate;
CREATE FUNCTION authenticate(username VARCHAR(20), password VARCHAR(20))
RETURNS TINYINT DETERMINISTIC
BEGIN
  DECLARE s CHAR(8);
  DECLARE pw_hash CHAR(64);
  DECLARE user_exists TINYINT DEFAULT 0;

  -- check if username actually appears in the user table
  SELECT salt, password_hash INTO s, pw_hash FROM users
  WHERE users.user_id = username;

  IF s IS NOT NULL AND pw_hash IS NOT NULL THEN
    SET user_exists = 1;
  END IF;
  
  -- return 1 only if 1) user exists and 2) password matches hash
  IF user_exists = 1 AND SHA2(CONCAT(s, password), 256) = pw_hash THEN
    RETURN 1; 
  ELSE
    RETURN 0; 
  END IF;
END !

DELIMITER ;

-- Create a procedure sp_change_password to generate a new salt and change the given
-- user's password to the given password (after salting and hashing)
DELIMITER !

DROP PROCEDURE IF EXISTS sp_change_password;
CREATE PROCEDURE sp_change_password(username VARCHAR(20), password VARCHAR(20))
BEGIN
  DECLARE new_salt CHAR(8);
  DECLARE new_password_hash BINARY(64);

  SELECT make_salt(8) INTO new_salt;
  SET new_password_hash = SHA2(CONCAT(new_salt, password), 256);

  UPDATE users SET salt = new_salt, password_hash = new_password_hash
  WHERE users.user_id = username;
END !

DELIMITER ;