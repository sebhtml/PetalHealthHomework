
desc "Destroy pokemons"
task :destroy_pokemons => :environment do
  Pokemon.destroy_all
end
