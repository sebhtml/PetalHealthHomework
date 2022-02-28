
require 'csv'
require 'net/http'
require 'digest'

class Pokemon < ApplicationRecord

  def self.maybe_download_file(uri, csv_file, csv_file_sha256)

    # Check if we already have the file with good sha256.
    if File.file? csv_file
      digestion = Digest::SHA256.hexdigest(File.open(csv_file).read)
      if digestion == csv_file_sha256
        return
      end
    end

    uri = URI.parse(uri)
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    resp = http.get(uri.request_uri)
    open(csv_file, "wb") do |file|
      file.write(resp.body)
    end
  end

  def self.import_pokemons

    # Download file
    csv_file = "tmp/storage/pokemon.csv"
    csv_file_sha256 = "02eabc49d3c70bc1e150891bdb9acb254910adfdfc12a6020c7b7117b2eca32f"
    uri = "https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv"

    maybe_download_file(uri, csv_file, csv_file_sha256)

    rows = []

    CSV.foreach(csv_file, headers: true) do |row|
      rows << row
    end

    inputs = rows.map do |row|
      Hash.new(
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

    self.create(inputs)
  end
end
