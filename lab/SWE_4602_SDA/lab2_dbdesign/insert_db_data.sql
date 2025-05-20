-- Regions
INSERT INTO region (name, description) VALUES ('Noxus', 'Region of Noxus');
INSERT INTO region (name, description) VALUES ('Ionia', 'Region of Ionia');
INSERT INTO region (name, description) VALUES ('Demacia', 'Region of Demacia');
INSERT INTO region (name, description) VALUES ('Piltover', 'Region of Piltover');

-- Players
INSERT INTO player (username, email, password_hash, region_id, last_login) 
VALUES 
('DariusMain', 'darius@example.com', 'hashedpassword123', 1, '2025-05-18 03:11:57'),
('AhriFox', 'ahri@example.com', 'hashedpassword123', 2, '2025-04-27 09:57:48'),
('LuxLaser', 'lux@example.com', 'hashedpassword123', 3, '2025-04-27 15:58:48'),
('JinxZap', 'jinx@example.com', 'hashedpassword123', 4, '2025-05-02 05:45:40');

-- Item Types
INSERT INTO item_type (name, description) VALUES 
('Potion', 'Potion description'),
('Weapon', 'Weapon description'),
('Ring', 'Ring description');

-- Items
INSERT INTO item (name, item_type_id, rarity, base_value, description) VALUES
('Health Potion', 1, 'Common', 50, 'Description of Health Potion'),
('Mana Potion', 1, 'Common', 60, 'Description of Mana Potion'),
('Ionian Blade', 2, 'Rare', 300, 'Description of Ionian Blade'),
('Ring of Fortitude', 3, 'Epic', 500, 'Description of Ring of Fortitude');

-- Quests
INSERT INTO quest (name, description, reward_experience) VALUES
('Rescue the Oracle', 'Save the oracle from danger.', 300),
('The Titan’s Vault', 'Explore the ancient vault.', 450);

-- Characters
INSERT INTO character (player_id, name, class) VALUES 
(1, 'Darius', 'Warrior'),
(2, 'Ahri', 'Mage'),
(3, 'Lux', 'Sorcerer'),
(4, 'Jinx', 'Marksman');

-- Character Inventory
INSERT INTO character_inventory (character_id, item_id, quantity) VALUES 
(1, 2, 1), -- Darius gets Mana Potion
(2, 3, 1), -- Ahri gets Ionian Blade
(3, 4, 1), -- Lux gets Ring of Fortitude
(4, 1, 1); -- Jinx gets Health Potion

-- Quest Participation
INSERT INTO quest_participation (character_id, quest_id, completed_at, is_up_vote, rating_timestamp) VALUES
(1, 2, NULL, NULL, NULL), -- Darius is in-progress
(2, 1, '2025-05-15 10:00:00', TRUE, '2025-05-15 10:05:00'), -- Ahri completed & upvoted
(3, 2, '2025-05-10 12:00:00', NULL, NULL), -- Lux completed, not rated
(4, 1, '2025-05-09 08:30:00', FALSE, '2025-05-09 08:35:00'); -- Jinx completed & downvoted

-- Quest Rewards
INSERT INTO quest_reward (quest_id, item_id, quantity, drop_chance) VALUES
(1, 1, 1, 100.00), -- Rescue the Oracle drops Health Potion
(2, 2, 1, 100.00); -- The Titan’s Vault drops Mana Potion
