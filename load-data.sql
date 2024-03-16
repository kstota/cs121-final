-- This script loads in 3 CSV files to fill the pokedex, nature, and 
-- type_weaknesses tables. 
-- Use the following commands: 
-- (if not created, enter CREATE DATABASE pokemondb first)
-- USE DATABASE pokemondb; 
-- source setup.sql; 
-- source load-pokemon.sql; 

LOAD DATA LOCAL INFILE 'data/pokedex.csv' INTO TABLE pokedex
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED 
BY '\r\n' IGNORE 1 ROWS;

UPDATE pokedex SET type_2 = NULLIF(type_2, '');

LOAD DATA LOCAL INFILE 'data/nature.csv' INTO TABLE nature
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED 
BY '\r\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/type_weaknesses.csv' INTO TABLE type_weaknesses
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED 
BY '\r\n' IGNORE 1 ROWS;

