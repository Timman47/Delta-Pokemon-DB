-- Create ability_list table first (must exist before foreign keys)
CREATE TABLE ability_list (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

-- Load ability data (relative path)
LOAD DATA LOCAL INFILE 'data/ability_data.csv' INTO TABLE ability_list
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Create delta_pokemon_list table with foreign key references
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

-- Load Pokemon data with ability name-to-ID conversion (relative path)
LOAD DATA LOCAL INFILE 'data/sample_data.csv' INTO TABLE delta_pokemon_list
(name, type1, type2, @ability1, @ability2, @hiddenability, hp, attack, defence, specialattack, specialdefence, speed, bst)
SET 
  ability1_id = (SELECT id FROM ability_list WHERE name = @ability1),
  ability2_id = (SELECT id FROM ability_list WHERE name = @ability2),
  hiddenability_id = (SELECT id FROM ability_list WHERE name = @hiddenability);