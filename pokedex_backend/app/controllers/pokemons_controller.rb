class PokemonsController < ActionController::API

  # GET /pokemons
  def index
    pokemons = Pokemon.all
    render json: pokemons
  end
end
