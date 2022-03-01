// This is the script for "Tests" for Postman test "localhost:3000/pokemons/pokemon_number/250"

// This idempotent test does the following:
// GET /pokemons/pokemon_number/:pokemon_number
// DELETE /pokemons/:id
// POST /pokemons
// GET /pokemons/pokemon_number/:pokemon_number

const hooh_pokemon_number = 250;

pm.test('Success', () => {
  const postRequest = {
    url: `http://localhost:3000/pokemons/pokemon_number/${hooh_pokemon_number}`,
    method: 'GET'
  };

  pm.sendRequest(postRequest, (error, response) => {
    pm.expect(response.code).to.be.equal(200);
    const jsonResponse = response.json();
    pm.expect(jsonResponse.length).to.be.above(0);
    const pokemon1 = jsonResponse[0];

    const postRequest = {
      url: `http://localhost:3000/pokemons/${pokemon1.id}`,
      method: 'DELETE'
    };

    pm.sendRequest(postRequest, (error, response) => {
      const postRequest = {
        url: "http://localhost:3000/pokemons",
        method: 'POST',
        header: {
          'Content-Type': 'application/json'
        },
        body: {
          mode: 'raw',
          raw: JSON.stringify(pokemon1)
        }
      };

      pm.sendRequest(postRequest, (error, response) => {
        const postRequest = {
          url: `http://localhost:3000/pokemons/pokemon_number/${hooh_pokemon_number}`,
          method: 'GET'
        };

        pm.sendRequest(postRequest, (error, response) => {
          pm.expect(response.code).to.be.equal(200);
          const jsonResponse = response.json();
          pm.expect(jsonResponse.length).to.be.above(0);
          const pokemon2 = jsonResponse[0];

          pm.expect(pokemon1.pokemon_number).to.be.equal(pokemon2.pokemon_number);
          pm.expect(pokemon1.id).to.not.be.equal(pokemon2.id);
        })
      });
    });
  });
});


