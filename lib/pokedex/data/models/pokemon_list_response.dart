import 'package:draftea_pokedex/pokedex/data/models/pokemon.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_response.freezed.dart';
part 'pokemon_list_response.g.dart';

@freezed
abstract class PokemonListResponse with _$PokemonListResponse {
  const factory PokemonListResponse({
    required int count,
    required List<Pokemon> results,
    String? next,
    String? previous,
  }) = _PokemonListResponse;

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);
}
