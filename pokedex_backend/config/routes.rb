Rails.application.routes.draw do
  resources :pokemons
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'pokemons/pokemon_number/:pokemon_number', to: 'pokemons#by_pokemon_number'
end
