import 'package:draftea_pokedex/pokedex/data/models/pokemon.dart';
import 'package:draftea_pokedex/pokedex/data/models/sprites.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail.freezed.dart';
part 'pokemon_detail.g.dart';

@freezed
abstract class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required int id,
    required String name,
    required Sprites sprites,
    required List<PokemonAbility> abilities,
  }) = _PokemonDetail;
  const PokemonDetail._();

  factory PokemonDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailFromJson(json);

  /// Get the official artwork image URL, falling back to front_default sprite
  String get imageUrl =>
      sprites.other?.officialArtwork?.frontDefault ??
      sprites.frontDefault ??
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  /// Get the display name (capitalized)
  String get displayName => name[0].toUpperCase() + name.substring(1);

  /// Get the formatted Pokemon ID (e.g., #001)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';
}
