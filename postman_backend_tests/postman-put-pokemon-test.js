// This is the script for "Tests" for Postman test "localhost:3000/pokemons/pokemon_number/25"

// This idempotent test does the following:
// Get pikachu, update pikachu to make it legendary, and then make pikachu not legendary.

const pikachu_pokemon_number = 25;

const getPokemon = (pokemon_number, callback) => {
  const postRequest = {
    url: `http://localhost:3000/pokemons/pokemon_number/${pokemon_number}`,
    method: 'GET'
  };

  pm.sendRequest(postRequest, callback);
};

const setLegendaryStatus = (pokemon_number, legendary, callback) => {
  const postRequest = {
    url: `http://localhost:3000/pokemons/${pokemon_number}`,
    method: 'PUT',
    header: {
      'Content-Type': 'application/json'
    },
    body: {
      mode: 'raw',
      raw: JSON.stringify({ legendary: legendary })
    }
  };

  pm.sendRequest(postRequest, callback);
};

const make_callback = (pokemon_name, expected_legendary, callback) => {
  return (error, response) => {
    console.log("This is a callback");
    console.log(response);
    pm.expect(response.code).to.be.equal(200);
    const jsonResponse = response.json();
    pm.expect(jsonResponse.length).to.be.above(0);
    const pokemon = jsonResponse[0];
    pm.expect(pokemon.name).to.be.equal(pokemon_name);
    const previousLegendary = pokemon.legendary;
    pm.expect(previousLegendary).to.be.equal(expected_legendary);
    const pokemon_id = pokemon.id;
    callback(pokemon_id);
  };
};

const testLegendaryConsequence = (error, response) => {
  console.log(error ? error : response.json());
  const after = (pokemon_id) => {
    setLegendaryStatus(pokemon_id, false, (error, response) => undefined);
  };
  getPokemon(pikachu_pokemon_number, make_callback("Pikachu", true, after));
};

pm.test('Success', function() {
  const after = (pokemon_id) => {
    setLegendaryStatus(pokemon_id, true, testLegendaryConsequence);
  };
  getPokemon(pikachu_pokemon_number, make_callback("Pikachu", false, after));
});


