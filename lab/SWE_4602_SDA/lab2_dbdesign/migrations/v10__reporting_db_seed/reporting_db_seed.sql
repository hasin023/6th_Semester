-- Connect to the database
\connect rpg_game;

-- Seed reporting.dim_region
INSERT INTO reporting.dim_region (region_id, name, description)
SELECT DISTINCT r.region_id, r.name, r.description
FROM operational.region r;

-- Seed reporting.dim_player
INSERT INTO reporting.dim_player (player_id, username, email, region_id)
SELECT DISTINCT p.player_id, p.username, p.email, p.region_id
FROM operational.player p;

-- Seed reporting.dim_quest
INSERT INTO reporting.dim_quest (quest_id, name, description, min_level, reward_experience)
SELECT DISTINCT q.quest_id, q.name, q.description, q.min_level, q.reward_experience
FROM operational.quest q;

-- Seed reporting.dim_item_type
INSERT INTO reporting.dim_item_type (item_type_id, name, description)
SELECT DISTINCT it.item_type_id, it.name, it.description
FROM operational.item_type it;

-- Seed reporting.dim_item
INSERT INTO reporting.dim_item (item_id, name, item_type_id, rarity, base_value)
SELECT DISTINCT i.item_id, i.name, i.item_type_id, i.rarity, i.base_value
FROM operational.item i;

-- Seed reporting.dim_time (based on quest_participation.started_at)
INSERT INTO reporting.dim_time (date, day, month, quarter, year, weekday)
SELECT DISTINCT
    qp.started_at::DATE AS date,
    EXTRACT(DAY FROM qp.started_at) AS day,
    EXTRACT(MONTH FROM qp.started_at) AS month,
    EXTRACT(QUARTER FROM qp.started_at) AS quarter,
    EXTRACT(YEAR FROM qp.started_at) AS year,
    TO_CHAR(qp.started_at, 'Day') AS weekday
FROM operational.quest_participation qp
WHERE qp.started_at IS NOT NULL;

-- Seed reporting.fact_quest_participation
INSERT INTO reporting.fact_quest_participation (
    participation_id,
    player_id,
    quest_id,
    time_id,
    region_id,
    rating,
    reward_points,
    duration_minutes,
    completed
)
SELECT
    qp.participation_id,
    c.player_id,
    qp.quest_id,
    dt.time_id,
    p.region_id,
    qp.rating,
    
    -- Calculate reward_points
    COALESCE((
        SELECT SUM(i.base_value * qr.quantity)
        FROM operational.quest_reward qr
        JOIN operational.item i ON qr.item_id = i.item_id
        WHERE qr.quest_id = qp.quest_id
    ), 0) AS reward_points,

    EXTRACT(EPOCH FROM (qp.completed_at - qp.started_at)) / 60 AS duration_minutes,
    qp.completed_at IS NOT NULL AS completed
FROM operational.quest_participation qp
JOIN operational.character c ON qp.character_id = c.character_id
JOIN operational.player p ON c.player_id = p.player_id
JOIN reporting.dim_time dt ON DATE(qp.started_at) = dt.date;


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
    'v10__reporting_db_seed/reporting_db_seed.sql',
    'Seed the reporting database with initial data for dimensions and fact tables using evolved schema (ratings, durations, time)',
    current_timestamp,
    current_timestamp
);
