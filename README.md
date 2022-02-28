
# TODO

- [x] Ruby on Rails backend API-only app
- [x] Test RESTful API with Postman
- [ ] Create a pokemon
- [x] Read pokemons
- [x] Read a pokemon
- [x] Update a pokemon
- [ ] Delete a pokemon
- [ ] Paginated list of pokemons
- [x] Solution in a GitHub repository

# Backend

This is a Ruby on Rails API-only application to manage Pokemons.

Data comes from https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv

# RESTful API resource paths

Note: JSON format is used.

| *HTTP verb and Resource path*                        | *Description* |
| ---                                                  | ---           |
| `GET /pokemons`                                      | Get all pokemons |
| `GET /pokemons/pokemon_number/:pokemon_number`       | Get all pokemons with the given pokemon number. |
| `GET /pokemons/:id`                                  | Get pokemon with the given id (not pokemon number). |
| `PUT /pokemons/:id`                                  | Update a pokemon using its unique id. See the Postman PUT test that makes Pikachu legendary. |

# Backend deployment

```bash

# Start using RVM
source /usr/local/rvm/scripts/rvm

# Destroy any existing pokemons
bundle exec rake destroy_pokemons

# Seed the database with pokemons from the CSV file
bundle exec rake import_pokemons

# Start the server in development mode
rails server
```

# Backend testing

Tests are written using RSpec and using Postman.


With RSpec:

```bash
cd pokedex_backend
bundle exec rspec spec/requests/pokemons_spec.rb
cd ..
```

With Postman:

use the collection in `postman_backend_tests`.



