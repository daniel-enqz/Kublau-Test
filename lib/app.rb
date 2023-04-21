require 'json'
require 'pry-byebug'
require_relative 'user'
require_relative 'services/application_service'
require_relative 'services/build_json_service'

file = File.read('./db/data.json')
data_hash = JSON.parse(file)
json_to_export = BuildJsonService.call(data_hash)

puts "Exporting to file..."
File.write('./db/results.json', json_to_export.to_json)
