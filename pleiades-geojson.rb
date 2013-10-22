#!/usr/bin/env ruby

require 'csv'
require 'json'

def locations_to_features(locations)
	features = []
	locations.each do |location|
		feature = {}
		feature["geometry"] = JSON.parse(location["geometry"]) unless (location["geometry"].nil? || location["geometry"] == "null")
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

def place_to_geojson(place)
	geojson = {}
	geojson["type"] = "FeatureCollection"
	%w{title id description}.each{|i| geojson[i] = place[i]}
	geojson["bbox"] = place["bbox"].split(',').map{|i| i.to_f} unless place["bbox"].nil?
	geojson["connectsWith"] = place["connectsWith"].split(',') unless place["connectsWith"].nil?
	geojson["reprPoint"] = [place["reprLong"].to_f, place["reprLat"].to_f]
	geojson["names"] = place["names"].map{|i| i["title"]} unless place["names"].nil?
	geojson["features"] = locations_to_features(place["locations"]) unless place["locations"].nil?
	return geojson
end

places_csv, names_csv, locations_csv = ARGV

places = {}
$stderr.puts "Parsing places..."
CSV.foreach(places_csv, :headers => true) do |row|
	places[row["id"]] = row.to_hash
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

places.each_key do |id|
	File.open("geojson/#{id}.geojson","w") do |f|
		f.write(JSON.pretty_generate(place_to_geojson(places[id])))
	end
end