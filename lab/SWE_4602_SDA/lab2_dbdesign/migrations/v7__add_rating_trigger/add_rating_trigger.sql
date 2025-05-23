-- Connect to the database
\connect rpg_game;

-- Update the recalculate average ratings for a specific quest or all quests
CREATE OR REPLACE PROCEDURE recalculate_quest_ratings(p_quest_id INT DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_quest_id IS NOT NULL THEN
        -- Update average_rating for a specific quest
        UPDATE quest q
        SET average_rating = (
            SELECT ROUND(AVG(rating)::NUMERIC, 2)
            FROM quest_participation
            WHERE quest_id = p_quest_id AND rating IS NOT NULL
        )
        WHERE q.quest_id = p_quest_id;
    ELSE
        -- Update average_rating for all quests
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
    END IF;
END;
$$;

-- Create a function to be used by the trigger
CREATE OR REPLACE FUNCTION trigger_recalculate_quest_ratings()
RETURNS TRIGGER AS $$
BEGIN
    CALL recalculate_quest_ratings(NEW.quest_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to recalculate average ratings after insert or update in quest_participation
CREATE TRIGGER quest_participation_rating_trigger
AFTER INSERT OR UPDATE OF rating, quest_id
ON quest_participation
FOR EACH ROW
EXECUTE FUNCTION trigger_recalculate_quest_ratings();

-- After the triggers are set, we can call the add_quest_rating procedure to add rating to a quest in the quest_participation table, from the terminal.
-- It should automatically update the average rating for that quest in the quest table.

-- (character_id, quest_id, rating)
-- Call the procedure directly in terminal using the following command
-- CALL add_quest_rating(3, 2, 4);

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
    'v7__add_rating_trigger/add_rating_trigger.sql',
    'Updated the recalculate average ratings for a specific quest or all quests and created a trigger to recalculate average ratings after insert or update in quest_participation.',
    current_timestamp,
    current_timestamp
);