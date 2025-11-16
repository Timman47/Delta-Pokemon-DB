CREATE TABLE delta_pokemon (
  name VARCHAR(255) NOT NULL PRIMARY KEY,
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

LOAD DATA INFILE '/data/sample_data.csv' INTO TABLE delta_pokemon
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;