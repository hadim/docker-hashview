#!/usr/bin/env bash

# Wait for database to be ready
while ! mysqladmin ping -h db --silent; do
    echo "* Waiting for database server to be up. Trying again in 5s."
    sleep 5s;
done

cd /hashview

HOST="db"
USERNAME="root"
PASSWORD="root_password"
DATABASE="hashview"
TABLE="users"

SQL_EXISTS=$(printf 'SHOW TABLES LIKE "%s"' "$TABLE")
MYSQL_CMD=""
if [[ $(mysql -h $HOST -u $USERNAME -p$PASSWORD -e "$SQL_EXISTS" $DATABASE 2> /dev/null) ]]
then
    echo "* The hashview database is already initialized."
else
    echo "* Initialize the hashview database."
    RACK_ENV=production TZ=$TZ bundle exec rake db:setup
fi

# This line is needed by Docker
# to reresh or update the `config/agent_config.json`
# file from host.
cat config/agent_config.json

# Start hashview.
echo "* Starting hashview..."
RACK_ENV=production TZ=$TZ foreman start
