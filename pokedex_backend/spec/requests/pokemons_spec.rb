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
end
