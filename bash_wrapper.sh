#!/bin/bash

echo $'\n1) Running postgres container and waiting 5 seconds before the next step ...'
Docker-compose up -d
sleep 5

echo $'\n2) Exporting database environmental variables ...'
set -a
. ./database.env
set +a

echo $'\n3) Creating tables shemas ...'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f sql_code/create_tables.sql

echo $'\n4) Populating tables with csv files ...'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f sql_code/populate_tables.sql

echo $'\n5) Computing daily statistics on the whole historic with a batch scrip ...'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f sql_code/batch_stats.sql

echo $'\n6) Checking that customers_stats table has been populated ...\nHere are the ten top customers per day followed by the number of repeater'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f  sql_code/test_stats.sql
