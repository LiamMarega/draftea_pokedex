import 'package:draftea_pokedex/pokedex/data/models/pokemon.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'pokemon_list_response.freezed.dart';
part 'pokemon_list_response.g.dart';

@freezed
@HiveType(typeId: 9)
abstract class PokemonListResponse with _$PokemonListResponse {
  const factory PokemonListResponse({
    @HiveField(0) required int count,
    @HiveField(1) required List<Pokemon> results,
    @HiveField(2) String? next,
    @HiveField(3) String? previous,
  }) = _PokemonListResponse;

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);
}
