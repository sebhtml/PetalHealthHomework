class PokemonsController < ActionController::API

  # GET /pokemons
  def index
    pokemons = Pokemon.all
    render json: pokemons
  end

  # GET /pokemons/pokemon_number/:pokemon_number
  def by_pokemon_number
    pokemons = Pokemon.by_pokemon_number params[:pokemon_number]
    render json: pokemons
  end

  # GET /pokemons/:id
  def show
    pokemon = Pokemon.find params[:id]
    render json: pokemon
  end
end
