CREATE DATABASE rpg_game;
\c rpg_game; -- Connect to the newly created database

CREATE TABLE region (
    region_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE player (
    player_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    region_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    FOREIGN KEY (region_id) REFERENCES region(region_id)
);

CREATE TABLE character (
    character_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    class VARCHAR(30) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    UNIQUE (player_id, name)
);

CREATE TABLE item_type (
    item_type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE item (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    item_type_id INT NOT NULL,
    rarity VARCHAR(20) NOT NULL,
    base_value INT NOT NULL,
    description TEXT,
    FOREIGN KEY (item_type_id) REFERENCES item_type(item_type_id)
);

CREATE TABLE player_favorite_item_type (
    player_id INT NOT NULL,
    item_type_id INT NOT NULL,
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (player_id, item_type_id),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (item_type_id) REFERENCES item_type(item_type_id)
);

CREATE TABLE character_inventory (
    character_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT DEFAULT 1,
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (character_id, item_id),
    FOREIGN KEY (character_id) REFERENCES character(character_id),
    FOREIGN KEY (item_id) REFERENCES item(item_id)
);

CREATE TABLE quest (
    quest_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    min_level INT DEFAULT 1,
    reward_experience INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quest_participation (
    participation_id SERIAL PRIMARY KEY,
    character_id INT NOT NULL,
    quest_id INT NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    is_up_vote BOOLEAN, -- NULL means not rated yet
    rating_timestamp TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES character(character_id),
    FOREIGN KEY (quest_id) REFERENCES quest(quest_id),
    UNIQUE (character_id, quest_id)
);

CREATE TABLE quest_reward (
    quest_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT DEFAULT 1,
    drop_chance NUMERIC(5,2) DEFAULT 100.00,
    PRIMARY KEY (quest_id, item_id),
    FOREIGN KEY (quest_id) REFERENCES quest(quest_id),
    FOREIGN KEY (item_id) REFERENCES item(item_id)
);

-- Indexes
CREATE INDEX idx_character_player ON character(player_id);
CREATE INDEX idx_inventory_character ON character_inventory(character_id);
CREATE INDEX idx_quest_participation_character ON quest_participation(character_id);
CREATE INDEX idx_quest_participation_quest ON quest_participation(quest_id);
CREATE INDEX idx_quest_reward_quest ON quest_reward(quest_id);
