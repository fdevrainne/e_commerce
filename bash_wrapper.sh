#!/bin/bash

echo $'\n1) Running postgres container and waiting 5 seconds before the next step ...'
Docker-compose up -d db
sleep 5

echo $'\n2) Exporting database environmental variables ...'
set -a
. ./database.env
set +a

echo $'\n3) Creating tables shemas ...'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f sql_code/create_tables.sql

echo $'\n4) Populating tables with csv files ...'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f sql_code/populate_tables.sql

echo $'\n5) Looping over the daily_stats.py script to inject historic data ...\nActually only looping over 4 days as a poc'
bash daily_stats_loop.sh 2016-09-04 2016-09-09

echo $'\n6) Printing ten top customers per day and number of repeaters ...'
Docker-compose run --rm dataengineering 2016-09-04

echo $'\n7) Computing daily statistics on the whole historic with a batch script ...'
Docker-compose run --rm db psql $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f sql_code/batch_stats.sql

echo $'\n8) Printing ten top customers per day and number of repeaters ...'
Docker-compose run --rm dataengineering 2016-09-04
