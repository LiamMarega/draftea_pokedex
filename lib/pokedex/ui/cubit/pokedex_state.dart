part of 'pokedex_cubit.dart';

enum PokemonListStatus { initial, loading, success, failure }

@freezed
abstract class PokedexState with _$PokedexState {
  const factory PokedexState({
    required ScrollController scrollController,
    @Default(PokemonListStatus.initial) PokemonListStatus status,
    @Default([]) List<PokemonDetail> pokemons,
    @Default(false) bool hasReachedMax,
    @Default(0) int currentOffset,
    @Default(false) bool isOffline,

    String? errorMessage,
  }) = _PokedexState;
}
