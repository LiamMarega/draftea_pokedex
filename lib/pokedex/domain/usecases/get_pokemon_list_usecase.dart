import 'package:draftea_pokedex/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:draftea_pokedex/pokedex/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

/// Use case to get a paginated list of Pokemon.
///
/// This orchestrates fetching the list and individual details,
/// converting everything to domain entities.
@injectable
class GetPokemonListUseCase
    implements UseCase<PokemonListResult, PaginationParams> {
  GetPokemonListUseCase(this._repository);

  final IPokemonRepository _repository;

  @override
  Future<PokemonListResult> call(PaginationParams params) async {
    return _repository.getPokemonList(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
