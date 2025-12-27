import 'package:draftea_pokedex/pokedex/data/datasources/pokemon_local_datasource.dart';
import 'package:draftea_pokedex/pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';
import 'package:draftea_pokedex/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPokemonRepository)
class PokemonRepository implements IPokemonRepository {
  PokemonRepository(this._remoteDataSource, this._localDataSource);

  final IPokemonRemoteDataSource _remoteDataSource;
  final IPokemonLocalDataSource _localDataSource;

  @override
  Future<PokemonListResponse> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Try to get from cache first
      final cached = await _localDataSource.getCachedPokemonList(offset);
      if (cached != null) {
        return cached;
      }

      // If not in cache, fetch from remote
      final remoteData = await _remoteDataSource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      // Save to cache
      await _localDataSource.cachePokemonList(offset, remoteData);

      return remoteData;
    } catch (_) {
      // If remote fails, try to return cached data anyway (even if it was null before)
      final cached = await _localDataSource.getCachedPokemonList(offset);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<PokemonDetail> getPokemon(int id) async {
    try {
      // Try to get from cache first
      final cached = await _localDataSource.getCachedPokemonDetail(id);
      if (cached != null) {
        return cached;
      }

      // If not in cache, fetch from remote
      final remoteData = await _remoteDataSource.getPokemon(id);

      // Save to cache
      await _localDataSource.cachePokemonDetail(remoteData);

      return remoteData;
    } catch (_) {
      // If remote fails, try to return cached data anyway
      final cached = await _localDataSource.getCachedPokemonDetail(id);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
