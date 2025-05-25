-- Connect to the database
\connect rpg_game;

-- Create the reporting schema
CREATE SCHEMA IF NOT EXISTS reporting;

-- Dimension: Time
CREATE TABLE reporting.dim_time (
    time_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    weekday VARCHAR(10) NOT NULL
);

-- Dimension: Player
CREATE TABLE reporting.dim_player (
    player_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    region_id INT NOT NULL
);

-- Dimension: Quest
CREATE TABLE reporting.dim_quest (
    quest_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    min_level INT NOT NULL,
    reward_experience INT NOT NULL
);

-- Dimension: Region
CREATE TABLE reporting.dim_region (
    region_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE reporting.dim_item_type (
    item_type_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Dimension: Item
CREATE TABLE reporting.dim_item (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    item_type_id INT NOT NULL,
    rarity VARCHAR(20) NOT NULL,
    base_value INT NOT NULL
);

-- Fact Table: Quest Participation
CREATE TABLE reporting.fact_quest_participation (
    participation_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    quest_id INT NOT NULL,
    time_id INT NOT NULL,
    region_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    reward_points INT,
    duration_minutes INT,
    completed BOOLEAN,
    FOREIGN KEY (player_id) REFERENCES reporting.dim_player(player_id),
    FOREIGN KEY (quest_id) REFERENCES reporting.dim_quest(quest_id),
    FOREIGN KEY (time_id) REFERENCES reporting.dim_time(time_id),
    FOREIGN KEY (region_id) REFERENCES reporting.dim_region(region_id)
);

-- Record the migration in the operational schema
INSERT INTO changelog._database_migrations (
    created_by,
    migration_name,
    migration_details,
    started_at,
    finished_at
)
VALUES (
    'postgres',
    'v9__reporting_schema/reporting_schema.sql',
    'Create the reporting schema and its tables for the RPG game reporting database',
    current_timestamp,
    current_timestamp
);