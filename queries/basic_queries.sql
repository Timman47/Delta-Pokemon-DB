-- Simple SELECT query
SELECT * FROM delta_pokemon_list;

-- SELECT Delta Pokemon with all their abilities.
SELECT name, ability1, ability2, hiddenability FROM delta_pokemon_list;

-- ORDER BY Delta Pokemon by BST (Base Stat Total) in descending order.
SELECT name, hp, attack, defence, specialattack, specialdefence, speed, bst FROM delta_pokemon_list ORDER BY bst DESC;