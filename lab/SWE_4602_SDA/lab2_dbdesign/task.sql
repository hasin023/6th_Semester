 -- 2A
ALTER TABLE quest_participation ADD COLUMN rating INT CHECK (rating BETWEEN 1 AND 5);

 -- 2B
UPDATE quest_participation
SET rating = CASE
    WHEN is_up_vote = true THEN 5
    WHEN is_up_vote = false THEN 1
    ELSE NULL
END
WHERE rating IS NULL;

ALTER TABLE quest_participation RENAME COLUMN is_up_vote TO deprecated_is_up_vote;

-- 3A
ALTER TABLE quest ADD COLUMN average_rating NUMERIC(3,2);

-- 3B
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

CALL recalculate_quest_ratings();


-- 4A

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

-- (char_id, quest_id, rating_value)
CALL add_quest_rating(3, 2, 4);
-- Need to add a trigger to recalculate the quest ratings


-- 4B

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

CALL get_quest_average_rating(1);

