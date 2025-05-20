## Running each script in PowerShell with Docker

Navigate into the project root (where `migrations/` exists), then run the following command in PowerShell to execute the SQL script inside the Docker container:

```powershell
Get-Content .\migrations\v0__init\init_db.sql | docker exec -i postgres_container psql -U postgres
```

## Running each script in PowerShell with Local PostgreSQL

```powershell
Get-Content .\migrations\v0__init\init_db.sql | psql -U postgres
```

This will setup the initial database and tables and also store this initial migration in the `_database_migrations` table. Check by running:

```powershell
SELECT * FROM _database_migrations;
```
