class AddPokemonNumberToPokemons < ActiveRecord::Migration[7.0]
  def change
    add_column :pokemons, :pokemon_number, :integer
  end
end
