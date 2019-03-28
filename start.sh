#!/usr/bin/env bash

# Wait for database to be ready
while ! mysqladmin ping -h db --silent; do
    echo "* Waiting for database server to be up."
    sleep 5s;
done

cd /hashview
RACK_ENV=production TZ=$TZ foreman start
