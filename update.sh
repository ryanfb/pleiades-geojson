#!/bin/bash

wget http://atlantides.org/downloads/pleiades/dumps/pleiades-places-latest.csv.gz http://atlantides.org/downloads/pleiades/dumps/pleiades-locations-latest.csv.gz http://atlantides.org/downloads/pleiades/dumps/pleiades-names-latest.csv.gz
gunzip *.csv.gz
./pleiades-geojson.rb pleiades-places-latest.csv pleiades-names-latest.csv pleiades-locations-latest.csv
rm -v *.csv
