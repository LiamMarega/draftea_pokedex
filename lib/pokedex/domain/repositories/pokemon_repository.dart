import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';
import 'package:draftea_pokedex/pokedex/domain/usecases/usecase.dart';

/// Abstract repository interface for Pokemon data.
///
/// This interface is defined in the domain layer and returns domain entities,
/// keeping the domain completely independent of data layer implementations.
abstract class IPokemonRepository {
  /// Get a paginated list of Pokemon.
  ///
  /// Returns a [PokemonListResult] containing the list of [Pokemon] entities,
  /// whether there are more results, and the total count.
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  /// Get a single Pokemon by its ID.
  ///
  /// Returns a [Pokemon] domain entity.
  Future<Pokemon> getPokemon(int id);
}
