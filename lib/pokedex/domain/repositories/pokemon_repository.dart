import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';

abstract class IPokemonRepository {
  Future<PokemonListResponse> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  // Future<List<PokemonDetail>> getPokemonListWithDetails({
  //   int limit = 20,
  //   int offset = 0,
  // });
  Future<PokemonDetail> getPokemon(int id);
}
