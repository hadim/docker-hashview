#!/usr/bin/env bash

# Wait for database to be ready
while ! mysqladmin ping -h db --silent; do
    echo "* Waiting for database server to be up."
    sleep 5s;
done

cd /hashview

HOST="db"
USERNAME="root"
PASSWORD="root_password"
DATABASE="hashview"
TABLE="users"

SQL_EXISTS=$(printf 'SHOW TABLES LIKE "%s"' "$TABLE")
if [[ $(mysql -h $HOST -u $USERNAME -p$PASSWORD -e "$SQL_EXISTS" $DATABASE) ]]
then
    echo "* The hashview database is already initialized."
else
    echo "* Initialize the hashview database."
    RACK_ENV=production TZ=$TZ bundle exec rake db:setup
fi

# Start hashview.
echo "* Starting hashview..."
sleep 5s
RACK_ENV=production TZ=$TZ foreman start
