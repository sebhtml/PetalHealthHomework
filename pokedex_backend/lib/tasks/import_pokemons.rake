
require 'csv'
require 'net/http'

desc "Import pokemons"
task :import_pokemons => :environment do
  # Download file
  uri = "https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv"
  uri = URI.parse(uri)
  http = Net::HTTP.new uri.host, uri.port
  http.use_ssl = true
  csv_file = "pokemon.csv"
  resp = http.get(uri.request_uri)
  open(csv_file, "wb") do |file|
    file.write(resp.body)
  end

  CSV.foreach(csv_file, headers: true) do |row|
    p row
    Pokemon.create(
      :pokemon_number => row["#"],
      :name => row["Name"],
      :type1 => row["Type 1"],
      :type2 => row["Type 2"],
      :total => row["Total"],
      :health_points => row["HP"],
      :attack => row["Attack"],
      :defense=> row["Defense"],
      :special_attack=> row["Sp. Atk"],
      :special_defense=> row["Sp. Def"],
      :speed => row["Speed"],
      :generation=> row["Generation"],
      :legendary=> row["Legendary"],
      )
  end
end
