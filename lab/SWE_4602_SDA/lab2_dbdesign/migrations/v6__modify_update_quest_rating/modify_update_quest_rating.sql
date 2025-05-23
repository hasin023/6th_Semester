-- Connect to the database
\connect rpg_game;

-- Update the add_quest_rating procedure to restrict rating only after quest completion
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

    -- Ensure participation exists and quest is completed
    IF NOT EXISTS (
        SELECT 1
        FROM quest_participation
        WHERE character_id = p_character_id
          AND quest_id = p_quest_id
          AND completed_at IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Rating not allowed: No completed participation found for character_id = %, quest_id = %',
            p_character_id, p_quest_id;
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

-- Test in terminal
-- (character_id, quest_id, rating_value)
-- CALL add_quest_rating(6, 4, 3); -- Should return error if quest not completed

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
    'v6__modify_update_quest_rating/modify_update_quest_rating.sql',
    'Updated procedure add_quest_rating() to restrict rating only after quest completion',
    current_timestamp,
    current_timestamp
);
