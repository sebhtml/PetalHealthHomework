require 'rails_helper'

RSpec.describe "Pokemons", type: :request do
  describe "GET /pokemons" do
    Pokemon.destroy_all
    Pokemon.import_pokemons
    it "works!" do
      get "/pokemons"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(800)
    end
  end
end
