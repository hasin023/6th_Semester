-- Connect to the database
\connect rpg_game;

 -- ADD COLUMN rating
ALTER TABLE quest_participation ADD COLUMN rating INT CHECK (rating BETWEEN 1 AND 5);

 -- BACKFILL rating
UPDATE quest_participation
SET rating = CASE
    WHEN is_up_vote = true THEN 5
    WHEN is_up_vote = false THEN 1
    ELSE NULL
END
WHERE rating IS NULL;

-- RENAME is_up_vote to deprecated_is_up_vote
ALTER TABLE quest_participation RENAME COLUMN is_up_vote TO deprecated_is_up_vote;


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
    'v2__modify_qp_rating/modify_quest_p_rating.sql',
    'Added rating column to quest_participation and backfilled values based on is_up_vote, to use 1-5 scale instead of boolean',
    current_timestamp,
    current_timestamp
);

