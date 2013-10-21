pleiades-geojson
----------------

Script and data for generating [GeoJSON](http://www.geojson.org/geojson-spec.html) from [Pleiades CSV data dumps](http://atlantides.org/downloads/pleiades/dumps/). Tries to be close to what you get if you request JSON from Pleiades itself, but could probably be improved in this area. Pretty-prints for diff readability.

    ./pleiades-geojson.rb pleiades-places-latest.csv pleiades-names-latest.csv pleiades-locations-latest.csv

Will write out a `.geojson` file for each place id, in the `geojson/` directory.