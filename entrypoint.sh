#!/bin/bash
# docker entrypoint script.

# assign a default for the database_user
DB_USER=${DATABASE_USER:-postgres}

while ! pg_isready -h $POSTGRES_HOST -U $POSTGRES_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/"

/app/bin/migrate
/app/bin/server