-- Connect to the database
\connect rpg_game;

-- Create the operational schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS operational;

-- Create the changelog schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS changelog;

-- Move tables to operational schema
ALTER TABLE public.region SET SCHEMA operational;
ALTER TABLE public.player SET SCHEMA operational;
ALTER TABLE public.character SET SCHEMA operational;
ALTER TABLE public.item_type SET SCHEMA operational;
ALTER TABLE public.item SET SCHEMA operational;
ALTER TABLE public.player_favorite_item_type SET SCHEMA operational;
ALTER TABLE public.character_inventory SET SCHEMA operational;
ALTER TABLE public.quest SET SCHEMA operational;
ALTER TABLE public.quest_participation SET SCHEMA operational;
ALTER TABLE public.quest_reward SET SCHEMA operational;

-- Move the _database_migrations table to the changelog schema
ALTER TABLE public._database_migrations SET SCHEMA changelog;

-- Record this migration in the changelog schema's _database_migrations table
INSERT INTO changelog._database_migrations (
    created_by,
    migration_name,
    migration_details,
    started_at,
    finished_at
)
VALUES (
    'postgres',
    'v8__operational_schema/operational_schema.sql',
    'Created operational schema, moved tables to operational schema, and recorded migration.',
    current_timestamp,
    current_timestamp
);
