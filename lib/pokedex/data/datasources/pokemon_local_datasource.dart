import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract class IPokemonLocalDataSource {
  Future<void> cachePokemonList(int offset, PokemonListResponse response);
  Future<PokemonListResponse?> getCachedPokemonList(int offset);
  Future<void> cachePokemonDetail(PokemonDetail detail);
  Future<PokemonDetail?> getCachedPokemonDetail(int id);
}

@LazySingleton(as: IPokemonLocalDataSource)
class PokemonLocalDataSource implements IPokemonLocalDataSource {
  static const String pokemonListBox = 'pokemon_list_box';
  static const String pokemonDetailBox = 'pokemon_detail_box';

  @override
  Future<void> cachePokemonList(
    int offset,
    PokemonListResponse response,
  ) async {
    final box = await Hive.openBox<PokemonListResponse>(pokemonListBox);
    await box.put(offset, response);
  }

  @override
  Future<PokemonListResponse?> getCachedPokemonList(int offset) async {
    final box = await Hive.openBox<PokemonListResponse>(pokemonListBox);
    return box.get(offset);
  }

  @override
  Future<void> cachePokemonDetail(PokemonDetail detail) async {
    final box = await Hive.openBox<PokemonDetail>(pokemonDetailBox);
    await box.put(detail.id, detail);
  }

  @override
  Future<PokemonDetail?> getCachedPokemonDetail(int id) async {
    final box = await Hive.openBox<PokemonDetail>(pokemonDetailBox);
    return box.get(id);
  }
}
