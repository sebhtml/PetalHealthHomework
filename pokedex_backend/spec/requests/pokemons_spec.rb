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
      pokemons = JSON.parse(response.body)
      expect(pokemons.size).to eq(800)
      pokemons_set = Set.new
      pokemons.each do |pokemon|
        pokemons_set << pokemon["name"]
      end
      expect(pokemons_set.size).to eq(800)
    end
  end

  describe "GET /pokemons/pokemon_number/:pokemon_number" do

    cool_pokemons = {
      1 => "Bulbasaur",
      4 => "Charmander",
      7 => "Squirtle",
      9 => "Blastoise",
      150 => "Mewtwo",
      151 => "Mew",
    }

    cool_pokemons.freeze

    cool_pokemons.each do |pokemon_number, name|
      it "Pokemon #{name} has the pokemon number #{pokemon_number}." do

        get "/pokemons/pokemon_number/#{pokemon_number}"
        expect(response).to have_http_status(200)
        outputs = JSON.parse(response.body)
        expect(outputs.size).to be >= 1
        pokemon = outputs.first
        expect(pokemon["name"]).to eq(name)

        get "/pokemons/#{pokemon["id"]}"
        expect(response).to have_http_status(200)
        pokemon2 = JSON.parse(response.body)
        expect(pokemon2["name"]).to eq(pokemon["name"])
      end
    end
  end

  pikachu_number = 25
  pikachu_number.freeze

  describe "PUT /pokemons/:id" do
    it "A Pokemon can be modified." do
      get "/pokemons/pokemon_number/#{pikachu_number}"
      expect(response).to have_http_status(200)
      outputs = JSON.parse(response.body)
      expect(outputs.size).to be == 1

      surprised_pikachu = outputs.first
      expect(surprised_pikachu["name"]).to eq("Pikachu")
      expect(surprised_pikachu["legendary"]).to eq(false)
      pikachu_id = surprised_pikachu["id"]
      put "/pokemons/#{pikachu_id}", params: { "pokemon": { "legendary": true }}

      get "/pokemons/pokemon_number/#{pikachu_number}"
      expect(response).to have_http_status(200)
      outputs = JSON.parse(response.body)
      expect(outputs.size).to be == 1
      legendary_pikachu = outputs.first
      expect(legendary_pikachu["name"]).to eq("Pikachu")
      expect(legendary_pikachu["legendary"]).to eq(true)
    end
  end
end
