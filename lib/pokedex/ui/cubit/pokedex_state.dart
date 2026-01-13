part of 'pokedex_cubit.dart';

enum PokemonListStatus { initial, loading, success, failure }

@freezed
abstract class PokedexState with _$PokedexState {
  const factory PokedexState({
    required ScrollController scrollController,
    @Default(PokemonListStatus.initial) PokemonListStatus status,
    // Updated to use Domain Entity 'Pokemon' instead of Data Model 'PokemonDetail'
    @Default([]) List<Pokemon> pokemons,
    @Default(false) bool hasReachedMax,
    @Default(0) int currentOffset,
    @Default(false) bool isOffline,
    @Default(0) int expectedCount,
    String? errorMessage,
  }) = _PokedexState;
}
