-- Connect to the database
\connect rpg_game;

 -- ADD COLUMN average_rating to quest table
ALTER TABLE quest ADD COLUMN average_rating NUMERIC(3,2);

-- Procedure to recalculate average ratings for quests from quest_participation
CREATE OR REPLACE PROCEDURE recalculate_quest_ratings()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE quest q
    SET average_rating = q_p.avg_rating
    FROM (
        SELECT
            quest_id,
            ROUND(AVG(rating)::NUMERIC, 2) AS avg_rating
        FROM quest_participation
        WHERE rating IS NOT NULL
        GROUP BY quest_id
    ) AS q_p
    WHERE q.quest_id = q_p.quest_id;
END;
$$;

-- Execute the procedure to recalculate average ratings
CALL recalculate_quest_ratings();

-- Create a trigger to recalculate average ratings after each insert or update in quest_participation
-- TODO

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
    'v3__add_avg_quest_rating/add_avg_quest_rating.sql',
    'Add average_rating column to quest table and create procedure to recalculate average ratings',
    current_timestamp,
    current_timestamp
);