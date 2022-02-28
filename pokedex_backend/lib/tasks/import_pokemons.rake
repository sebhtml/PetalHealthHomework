
desc "Import pokemons"
task :import_pokemons => :environment do
  Pokemon.import_pokemons
end
