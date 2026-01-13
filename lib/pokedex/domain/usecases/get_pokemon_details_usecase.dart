import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';
import 'package:draftea_pokedex/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:draftea_pokedex/pokedex/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

/// Use case to get details of a specific Pokemon by ID.
@injectable
class GetPokemonDetailsUseCase implements UseCase<Pokemon, int> {
  GetPokemonDetailsUseCase(this._repository);

  final IPokemonRepository _repository;

  @override
  Future<Pokemon> call(int id) async {
    return _repository.getPokemon(id);
  }
}
