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

  describe "DELETE /pokemons/:id" do
    flabebe_pokemon_number = 669
    it "A Pokemon can be deleted." do
      get "/pokemons/pokemon_number/#{flabebe_pokemon_number}"
      expect(response).to have_http_status(200)
      outputs = JSON.parse(response.body)
      expect(outputs.size).to be == 1

      flabebe_pokemon = outputs.first
      expect(flabebe_pokemon["name"]).to eq("Flabébé")
      flabebe_id = flabebe_pokemon["id"]
      delete "/pokemons/#{flabebe_id}"

      get "/pokemons/pokemon_number/#{flabebe_pokemon_number}"
      expect(response).to have_http_status(200)
      outputs = JSON.parse(response.body)
      expect(outputs.size).to be == 0

      expect { get "/pokemons/#{flabebe_id}" }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST /pokemons" do
    it "A Pokemon can be created." do
      payload = {
        :pokemon_number => 999999,
        :name => "OmegatronPiSquared",
        :type1 => "Dragon",
        :type2 => "Fairy",
        :total => 0,
        :health_points => 200,
        :attack => 999,
        :defense => 2048,
        :special_attack => 1920,
        :special_defense => 1080,
        :speed => 999,
        :generation => 999,
        :legendary => true
      }

      # Generate total.
      stats = [:health_points, :attack, :defense, :special_attack, :special_defense, :speed, :generation]
      stats.each do |stat|
        payload[:total] += payload[stat]
      end

      post "/pokemons", params: payload

      get "/pokemons/pokemon_number/#{payload[:pokemon_number]}"
      expect(response).to have_http_status(200)
      outputs = JSON.parse(response.body)
      pokemon = outputs.first
      expect(pokemon["name"]).to eq(payload[:name])
    end
  end

  describe "GET /pokemons/page/:page/per_page/:per_page" do
    it "Pokemons can be consulted in a paginated way." do
      # Read all the pages to get all the pokemons.
      pokemons1 = []
      page = 1
      per_page = 100

      while true
        get "/pokemons/page/#{page}/per_page/#{per_page}"
        expect(response).to have_http_status(200)
        page_pokemons = JSON.parse(response.body)
        pokemons1.concat(page_pokemons)
        if page_pokemons.size < per_page
          break
        end
        page += 1
      end

      # Get all the pokemons in one shot.
      get "/pokemons"
      expect(response).to have_http_status(200)
      pokemons2 = JSON.parse(response.body)

      # Both pokemons lists must be equal.
      expect(pokemons1).to eq(pokemons2)
    end
  end
end
