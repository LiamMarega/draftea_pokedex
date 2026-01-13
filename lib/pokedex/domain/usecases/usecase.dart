import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';

/// Base class for use cases.
/// Use cases encapsulate business logic and orchestrate the flow of data.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<Type> {
  Future<Type> call();
}

/// Parameters for paginated list requests
class PaginationParams {
  const PaginationParams({
    this.limit = 20,
    this.offset = 0,
  });

  final int limit;
  final int offset;
}

/// Result of a paginated Pokemon list request
class PokemonListResult {
  const PokemonListResult({
    required this.pokemons,
    required this.hasMore,
    required this.total,
  });

  final List<Pokemon> pokemons;
  final bool hasMore;
  final int total;
}
