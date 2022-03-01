// This is the script for "Tests" for Postman test "localhost:3000/pokemons/page/1/per_page/33"

// This test first read every page of pokemons using
//   GET /pokemons/page/:page/per_page/:per_page
// Once all pages have been read, another list of pokemons is obtained using
//   GET /pokemons
// Finally, both lists are compared. The test passes if they are equal.

pm.test('Success', () => {
  let currentPage = 1;
  const perPage = 33;
  let paginatedPokemons = [];

  const readPage = () => {
    const postRequest = {
      url: `http://localhost:3000/pokemons/page/${currentPage}/per_page/${perPage}`,
      method: 'GET'
    };

    pm.sendRequest(postRequest, (error, response) => {
      pm.expect(response.code).to.be.equal(200);
      const jsonResponse = response.json();
      pm.expect(jsonResponse.length).to.be.below(perPage + 1);
      paginatedPokemons = paginatedPokemons.concat(jsonResponse);

      if (jsonResponse.length == perPage) {
        ++currentPage;
        readPage();
      } else {
        // We are done reading pages.
        // Now read all pokemons and compare both arrays.
        const postRequest = {
          url: `http://localhost:3000/pokemons`,
          method: 'GET'
        };

        pm.sendRequest(postRequest, (error, response) => {
          pm.expect(response.code).to.be.equal(200);
          const allPokemons = response.json();

          pm.expect(paginatedPokemons.length).to.be.equal(allPokemons.length);

          for (let i = 0; i != paginatedPokemons.length; ++i) {
            pm.expect(paginatedPokemons[i].pokemon_number).to.be.equal(allPokemons[i].pokemon_number);
            pm.expect(paginatedPokemons[i].name).to.be.equal(allPokemons[i].name);
          }
        });
      }
    });
  };
  readPage();
});
