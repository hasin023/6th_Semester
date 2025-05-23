-- Connect to the database
\connect rpg_game;

-- Procedure to get the average rating of a quest by quest_id
CREATE OR REPLACE PROCEDURE get_quest_average_rating(p_quest_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    avg_rating NUMERIC(3,2);
BEGIN
    SELECT average_rating
    INTO avg_rating
    FROM quest
    WHERE quest_id = p_quest_id;

    IF avg_rating IS NULL THEN
        RAISE NOTICE 'No rating found for quest_id %', p_quest_id;
    ELSE
        RAISE NOTICE 'Average rating for quest_id % is %', p_quest_id, avg_rating;
    END IF;
END;
$$;

-- Call procedure with different quest_ids
CALL get_quest_average_rating(1);
CALL get_quest_average_rating(3);

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
    'v5__get_quest_rating/get_quest_rating.sql',
    'Created procedure get_quest_average_rating to retrieve average rating for a quest by quest_id',
    current_timestamp,
    current_timestamp
);