-- Create ability_list table first (must exist before foreign keys)
CREATE TABLE ability_list (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

-- Load ability data
LOAD DATA LOCAL INFILE '/home/timman47/Documents/Delta-Pokemon-DB/data/ability_data.csv' INTO TABLE ability_list
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(id, name, description);

-- Create temporary table to load Pokemon data with text abilities first
CREATE TEMPORARY TABLE temp_pokemon_list (
  name VARCHAR(255) NOT NULL,
  type1 CHAR(8) NOT NULL,
  type2 CHAR(8),
  ability1 VARCHAR(255) NOT NULL,
  ability2 VARCHAR(255),
  hiddenability VARCHAR(255),
  hp INT NOT NULL,
  attack INT NOT NULL,
  defence INT NOT NULL,
  specialattack INT NOT NULL,
  specialdefence INT NOT NULL,
  speed INT NOT NULL,
  bst INT NOT NULL
);

-- Load Pokemon data into temporary table
LOAD DATA LOCAL INFILE '/home/timman47/Documents/Delta-Pokemon-DB/data/sample_data.csv' INTO TABLE temp_pokemon_list
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- Create final delta_pokemon_list table with foreign key references
CREATE TABLE delta_pokemon_list (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  type1 CHAR(8) NOT NULL,
  type2 CHAR(8),
  ability1_id INT NOT NULL,
  ability2_id INT,
  hiddenability_id INT,
  hp INT NOT NULL,
  attack INT NOT NULL,
  defence INT NOT NULL,
  specialattack INT NOT NULL,
  specialdefence INT NOT NULL,
  speed INT NOT NULL,
  bst INT NOT NULL,
  FOREIGN KEY (ability1_id) REFERENCES ability_list(id),
  FOREIGN KEY (ability2_id) REFERENCES ability_list(id),
  FOREIGN KEY (hiddenability_id) REFERENCES ability_list(id)
);

-- Insert data from temporary table with ability name-to-ID conversion
INSERT INTO delta_pokemon_list (name, type1, type2, ability1_id, ability2_id, hiddenability_id, hp, attack, defence, specialattack, specialdefence, speed, bst)
SELECT 
  t.name,
  t.type1,
  t.type2,
  a1.id as ability1_id,
  a2.id as ability2_id,
  a3.id as hiddenability_id,
  t.hp,
  t.attack,
  t.defence,
  t.specialattack,
  t.specialdefence,
  t.speed,
  t.bst
FROM temp_pokemon_list t
JOIN ability_list a1 ON t.ability1 = a1.name
LEFT JOIN ability_list a2 ON t.ability2 = a2.name
LEFT JOIN ability_list a3 ON t.hiddenability = a3.name;

-- Drop temporary table
DROP TEMPORARY TABLE temp_pokemon_list;

-- Create a view that shows ability names instead of IDs
CREATE VIEW pokemon_with_abilities AS
SELECT 
  p.id,
  p.name,
  p.type1,
  p.type2,
  a1.name as ability1,
  a2.name as ability2,
  a3.name as hiddenability,
  p.hp,
  p.attack,
  p.defence,
  p.specialattack,
  p.specialdefence,
  p.speed,
  p.bst
FROM delta_pokemon_list p
JOIN ability_list a1 ON p.ability1_id = a1.id
LEFT JOIN ability_list a2 ON p.ability2_id = a2.id
LEFT JOIN ability_list a3 ON p.hiddenability_id = a3.id;