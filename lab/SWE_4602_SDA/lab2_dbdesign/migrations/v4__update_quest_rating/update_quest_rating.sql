-- Connect to the database
\connect rpg_game;

-- Create procedure to update a quest rating in quest_participation table
CREATE OR REPLACE PROCEDURE add_quest_rating(
    p_character_id INT,
    p_quest_id INT,
    p_rating_value INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_rating_value < 1 OR p_rating_value > 5 THEN
        RAISE EXCEPTION 'Rating value must be between 1 and 5';
    END IF;

    UPDATE quest_participation
    SET
        rating = p_rating_value,
        rating_timestamp = CURRENT_TIMESTAMP
    WHERE character_id = p_character_id AND quest_id = p_quest_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No participation found for character_id = %, quest_id = %', p_character_id, p_quest_id;
    END IF;
END;
$$;

-- (character_id, quest_id, rating_value)
CALL add_quest_rating(1, 2, 3); -- This will work and add a rating even though this character has not completed the quest, as the procedure does not check for completion, YET. That restriction has been added in the v6 migration. So after the v6 migration, we have another test case, with the (6, 4, 3) parameters, which will return an error if the quest is not completed. Test that in the terminal.


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
    'v4__update_quest_rating/update_quest_rating.sql',
    'Created procedure add_quest_rating to add or update ratings in quest_participation',
    current_timestamp,
    current_timestamp
);