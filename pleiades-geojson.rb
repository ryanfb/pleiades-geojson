#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'
require 'json'

def locations_to_features(locations)
  features = []
  locations.each do |location|
    feature = {}
    if location["geometry"].nil? || (location["geometry"] == "null")
      feature["geometry"] = nil
    else
      feature["geometry"] = JSON.parse(location["geometry"])
    end
    feature["id"] = location["id"]
    feature["type"] = "Feature"
    feature["properties"] = {
      "description" => location["description"],
      "location_precision" => location["locationPrecision"],
      "title" => location["title"],
      "link" => "http://pleiades.stoa.org" + location["path"]
    }
    features << feature
  end
  return features
end

def reprpoint_to_feature(long, lat)
  feature = {}
  feature["type"] = "Feature"
  if (long.to_f == 0.0) && (lat.to_f == 0.0)
    feature["geometry"] = nil
  else
    feature["geometry"] = {
      "type" => "Point",
      "coordinates" => [long.to_f, lat.to_f]
    }
  end
  feature["properties"] = {"description" => "representative point"}
  return feature
end

def place_to_geojson(place)
  geojson = {}
  geojson["type"] = "FeatureCollection"
  %w{title id}.each{|i| geojson[i] = place[i]}
  geojson["bbox"] = place["bbox"].split(',').map{|i| i.to_f} unless place["bbox"].nil?
  # geojson["properties"] = {}
  geojson["description"] = place["description"]
  geojson["connectsWith"] = place["connectsWith"].split(',') unless place["connectsWith"].nil?
  geojson["names"] = place["names"].map{|i| i["title"]} unless place["names"].nil?
  geojson["features"] = [reprpoint_to_feature(place["reprLong"].to_f, place["reprLat"].to_f)]
  geojson["features"] += locations_to_features(place["locations"]) unless place["locations"].nil?
  return geojson
end

places_csv, names_csv, locations_csv = ARGV

places = {}
$stderr.puts "Parsing places..."
CSV.foreach(places_csv, :headers => true) do |row|
  places[row["path"]] = row.to_hash
end

$stderr.puts "Parsing names..."
CSV.foreach(names_csv, :headers => true) do |row|
  unless places[row["pid"]].nil?
    places[row["pid"]]["names"] ||= []
    places[row["pid"]]["names"] << row.to_hash
  end
end

$stderr.puts "Parsing locations..."
CSV.foreach(locations_csv, :headers => true) do |row|
  unless places[row["pid"]].nil?
    places[row["pid"]]["locations"] ||= []
    places[row["pid"]]["locations"] << row.to_hash
  end
end

names = []
places.each_key do |id|
  place_id = places[id]['id']
  place_geojson = place_to_geojson(places[id])
  File.open("geojson/#{place_id}.geojson","w") do |f|
    f.write(JSON.pretty_generate(place_geojson))
  end

  unless places[id]["names"].nil?
    places[id]["names"].map{|n| [n["title"],n["nameAttested"]]}.flatten.compact.uniq.each do |name|
      names << [name, place_id]
    end
  end
  names << [places[id]["title"], place_id] unless places[id]["title"].nil?
end

File.open("name_index.json", "w") do |f|
  f.write(JSON.generate(names.uniq))
end
