import 'package:draftea_pokedex/core/utils/batch_executor.dart';
import 'package:draftea_pokedex/pokedex/data/datasources/pokemon_local_datasource.dart';
import 'package:draftea_pokedex/pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:draftea_pokedex/pokedex/data/mappers/pokemon_mapper.dart';
// Import data models, aliasing model.Pokemon to avoid conflict with entity.Pokemon
import 'package:draftea_pokedex/pokedex/data/models/pokemon.dart' as model;
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';
import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';
import 'package:draftea_pokedex/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:draftea_pokedex/pokedex/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPokemonRepository)
class PokemonRepository implements IPokemonRepository {
  PokemonRepository(this._remoteDataSource, this._localDataSource);

  final IPokemonRemoteDataSource _remoteDataSource;
  final IPokemonLocalDataSource _localDataSource;

  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final listResponse = await _fetchListResponse(limit, offset);

      final ids = listResponse.results.map((model.Pokemon r) {
        final uri = Uri.parse(r.url);
        final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
        return int.parse(segments.last);
      }).toList();

      final pokemonDetails = await BatchExecutor.execute<Pokemon>(
        tasks: ids
            .map(
              (id) =>
                  () => getPokemon(id),
            )
            .toList(),
      );

      return PokemonListResult(
        pokemons: pokemonDetails,
        hasMore: listResponse.next != null,
        total: listResponse.count,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PokemonListResponse> _fetchListResponse(
    int limit,
    int offset,
  ) async {
    try {
      final cached = await _localDataSource.getCachedPokemonList(offset);
      if (cached != null) {
        return cached;
      }

      final remoteData = await _remoteDataSource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      await _localDataSource.cachePokemonList(offset, remoteData);

      return remoteData;
    } catch (_) {
      final cached = await _localDataSource.getCachedPokemonList(offset);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<Pokemon> getPokemon(int id) async {
    try {
      final cached = await _localDataSource.getCachedPokemonDetail(id);
      if (cached != null) {
        return PokemonMapper.toEntity(cached);
      }

      final remoteData = await _remoteDataSource.getPokemon(id);
      await _localDataSource.cachePokemonDetail(remoteData);

      return PokemonMapper.toEntity(remoteData);
    } catch (_) {
      final cached = await _localDataSource.getCachedPokemonDetail(id);
      if (cached != null) return PokemonMapper.toEntity(cached);
      rethrow;
    }
  }
}
