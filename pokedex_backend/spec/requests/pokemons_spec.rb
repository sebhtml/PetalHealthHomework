require 'rails_helper'

RSpec.describe "pokemons", type: :request do

  before(:all) do
    Pokemon.destroy_all
    Pokemon.import_pokemons
  end

  describe "GET /pokemons" do
    it "works!" do
      get "/pokemons"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(800)
    end
  end

  describe "GET /pokemons/pokemon_number/{pokemon_number}" do

    cool_pokemons = {
      1 => "Bulbasaur",
      4 => "Charmander",
      7 => "Squirtle",
      9 => "Blastoise",
      150 => "Mewtwo",
      151 => "Mew",
    }

    cool_pokemons.each do |pokemon_number, name|
      it "Pokemon #{name} has the pokemon number #{pokemon_number}." do
        get "/pokemons/pokemon_number/#{pokemon_number}"
        expect(response).to have_http_status(200)
        outputs = JSON.parse(response.body)
        expect(outputs.size).to be >= 1
        pokemon = outputs.first
        expect(pokemon["name"]).to eq(name)
      end
    end
  end
end
