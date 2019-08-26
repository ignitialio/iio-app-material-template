#!/bin/sh

export POPULATE_ALL=true
# don't forget to add your server to Mongo Atlas white list
# export MONGODB_PASSWORD=<your_password>

./tools/js/populate_db-mongo.js
