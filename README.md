pleiades-geojson
----------------

Script and data for generating [GeoJSON](http://www.geojson.org/geojson-spec.html) from [Pleiades CSV data dumps](http://atlantides.org/downloads/pleiades/dumps/). Tries to be close to what you get if you request JSON from Pleiades itself, but could probably be improved in this area. Pretty-prints for diff readability.

    ./pleiades-geojson.rb pleiades-places-latest.csv pleiades-names-latest.csv pleiades-locations-latest.csv

Will write out a `.geojson` file for each place id, in the `geojson/` directory.
The script will also write out a `name_index.json` file, used for [Pleiades Static Search](https://github.com/ryanfb/pleiades-static-search).

Data License
------------

Copyright © [Ancient World Mapping Center](http://www.unc.edu/awmc/) and [Institute for the Study of the Ancient World](http://www.nyu.edu/isaw/). Sharing and remixing permitted under terms of the [Creative Commons Attribution 3.0 License (cc-by)](http://creativecommons.org/licenses/by/3.0/us/).

Code License
------------

Copyright (c) 2014 Ryan Baumann

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.