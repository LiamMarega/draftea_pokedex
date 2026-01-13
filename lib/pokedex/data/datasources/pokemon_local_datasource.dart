import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract class IPokemonLocalDataSource {
  Future<void> cachePokemonList(int offset, PokemonListResponse response);
  Future<PokemonListResponse?> getCachedPokemonList(int offset);
  Future<void> cachePokemonDetail(PokemonDetail detail);
  Future<PokemonDetail?> getCachedPokemonDetail(int id);
  Future<void> cachePokemonDetails(List<PokemonDetail> details);
  Future<List<PokemonDetail>> getCachedPokemonDetails(List<int> ids);
}

@LazySingleton(as: IPokemonLocalDataSource)
class PokemonLocalDataSource implements IPokemonLocalDataSource {
  static const String pokemonListBox = 'pokemon_list_box';
  static const String pokemonDetailBox = 'pokemon_detail_box';

  Box<PokemonListResponse>? _listBox;
  Box<PokemonDetail>? _detailBox;

  Future<Box<PokemonListResponse>> get _pokemonListBox async {
    _listBox ??= await Hive.openBox<PokemonListResponse>(pokemonListBox);
    return _listBox!;
  }

  Future<Box<PokemonDetail>> get _pokemonDetailBox async {
    _detailBox ??= await Hive.openBox<PokemonDetail>(pokemonDetailBox);
    return _detailBox!;
  }

  @override
  Future<void> cachePokemonList(
    int offset,
    PokemonListResponse response,
  ) async {
    final box = await _pokemonListBox;
    await box.put(offset, response);
  }

  @override
  Future<PokemonListResponse?> getCachedPokemonList(int offset) async {
    final box = await _pokemonListBox;
    return box.get(offset);
  }

  @override
  Future<void> cachePokemonDetail(PokemonDetail detail) async {
    final box = await _pokemonDetailBox;
    await box.put(detail.id, detail);
  }

  @override
  Future<PokemonDetail?> getCachedPokemonDetail(int id) async {
    final box = await _pokemonDetailBox;
    return box.get(id);
  }

  @override
  Future<void> cachePokemonDetails(List<PokemonDetail> details) async {
    final box = await _pokemonDetailBox;
    final entries = {for (final d in details) d.id: d};
    await box.putAll(entries);
  }

  @override
  Future<List<PokemonDetail>> getCachedPokemonDetails(List<int> ids) async {
    final box = await _pokemonDetailBox;
    return ids.map(box.get).whereType<PokemonDetail>().toList();
  }
}
