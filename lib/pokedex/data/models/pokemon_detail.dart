import 'package:draftea_pokedex/pokedex/data/models/pokemon.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_stat.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_type_slot.dart';
import 'package:draftea_pokedex/pokedex/data/models/sprites.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'pokemon_detail.freezed.dart';
part 'pokemon_detail.g.dart';

@freezed
@HiveType(typeId: 0)
abstract class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required Sprites sprites,
    @HiveField(3) required List<PokemonAbility> abilities,
    @HiveField(5) required int height, @HiveField(6) required int weight, @HiveField(4) @Default([]) List<PokemonTypeSlot> types,
    @HiveField(7) @Default([]) List<PokemonStat> stats,
    @HiveField(8) @JsonKey(name: 'base_experience') int? baseExperience,
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
