-- Connect to the database
\connect rpg_game;

-- Regions
INSERT INTO region (name, description) VALUES
('Noxus', 'Region of Noxus'),
('Ionia', 'Region of Ionia'),
('Demacia', 'Region of Demacia'),
('Piltover', 'Region of Piltover'),
('Zaun', 'Region of Zaun'),
('Freljord', 'Region of Freljord');

-- Players
INSERT INTO player (username, email, password_hash, region_id, last_login) VALUES
('DariusMain', 'darius@example.com', 'hashedpassword123', 1, '2025-05-18 03:11:57'),
('AhriFox', 'ahri@example.com', 'hashedpassword123', 2, '2025-04-27 09:57:48'),
('LuxLaser', 'lux@example.com', 'hashedpassword123', 3, '2025-04-27 15:58:48'),
('JinxZap', 'jinx@example.com', 'hashedpassword123', 4, '2025-05-02 05:45:40'),
('ViktorTech', 'viktor@example.com', 'hashedpassword123', 5, '2025-05-05 14:20:10'),
('AsheArrow', 'ashe@example.com', 'hashedpassword123', 6, '2025-05-01 12:00:00');

-- Item Types
INSERT INTO item_type (name, description) VALUES
('Potion', 'Potion description'),
('Weapon', 'Weapon description'),
('Ring', 'Ring description'),
('Armor', 'Armor description'),
('Scroll', 'Scroll description'),
('Trinket', 'Trinket description');

-- Items
INSERT INTO item (name, item_type_id, rarity, base_value, description) VALUES
('Health Potion', 1, 'Common', 50, 'Restores health'),
('Mana Potion', 1, 'Common', 60, 'Restores mana'),
('Ionian Blade', 2, 'Rare', 300, 'Sword of the Ionians'),
('Ring of Fortitude', 3, 'Epic', 500, 'Boosts defense'),
('Freljord Cloak', 4, 'Rare', 400, 'Provides cold resistance'),
('Scroll of Fireball', 5, 'Uncommon', 200, 'Casts fireball spell');

-- Quests
INSERT INTO quest (name, description, reward_experience) VALUES
('Rescue the Oracle', 'Save the oracle from danger.', 300),
('The Titan’s Vault', 'Explore the ancient vault.', 450),
('Secrets of Zaun', 'Investigate chemical threats.', 350),
('Defend the Wall', 'Hold off Noxian invaders.', 500),
('Iceborn Trial', 'Survive the northern test.', 600),
('Echoes of Magic', 'Collect ancient scrolls.', 320);

-- Characters
INSERT INTO character (player_id, name, class) VALUES 
(1, 'Darius', 'Warrior'),
(2, 'Ahri', 'Mage'),
(3, 'Lux', 'Sorcerer'),
(4, 'Jinx', 'Marksman'),
(5, 'Viktor', 'Engineer'),
(6, 'Ashe', 'Archer');

-- Character Inventory
INSERT INTO character_inventory (character_id, item_id, quantity) VALUES 
(1, 2, 1),  -- Darius gets Mana Potion
(2, 3, 1),  -- Ahri gets Ionian Blade
(3, 4, 1),  -- Lux gets Ring of Fortitude
(4, 1, 1),  -- Jinx gets Health Potion
(5, 5, 1),  -- Viktor gets Freljord Cloak
(6, 6, 2);  -- Ashe gets 2 Scrolls of Fireball

-- Quest Participation
INSERT INTO quest_participation (character_id, quest_id, completed_at, is_up_vote, rating_timestamp) VALUES
(1, 2, NULL, NULL, NULL),  -- Darius is in-progress
(2, 1, '2025-05-15 10:00:00', TRUE, '2025-05-15 10:05:00'),
(3, 2, '2025-05-10 12:00:00', NULL, NULL),
(4, 1, '2025-05-09 08:30:00', FALSE, '2025-05-09 08:35:00'),
(5, 3, '2025-05-14 11:00:00', TRUE, '2025-05-14 11:03:00'),
(6, 4, NULL, NULL, NULL);  -- Ashe is in-progress

-- Quest Rewards
INSERT INTO quest_reward (quest_id, item_id, quantity, drop_chance) VALUES
(1, 1, 1, 100.00), -- Health Potion
(2, 2, 1, 100.00), -- Mana Potion
(3, 5, 1, 75.00),  -- Freljord Cloak
(4, 3, 1, 80.00),  -- Ionian Blade
(5, 4, 1, 60.00),  -- Ring of Fortitude
(6, 6, 2, 90.00);  -- 2 Scrolls of Fireball


-- Record the migration in the _database_migrations table
INSERT INTO _database_migrations (
    created_by,
    migration_name,
    migration_details,
    started_at,
    finished_at
)
VALUES (
    'postgres',
    'v1__seed/seed_data.sql',
    'Seeded initial data for regions, players, items, quests, characters, and quest participation',
    current_timestamp,
    current_timestamp
);

