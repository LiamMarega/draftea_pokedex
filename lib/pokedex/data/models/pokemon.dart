import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
@HiveType(typeId: 8)
abstract class Pokemon with _$Pokemon {
  const factory Pokemon({
    @HiveField(0) required String name,
    @HiveField(1) required String url,
  }) = _Pokemon;
  const Pokemon._();

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.parse(segments.last);
  }

  static const double minHeight = 210;
  static const double maxThumbnailHeight = 140;
}

@freezed
@HiveType(typeId: 4)
abstract class PokemonAbility with _$PokemonAbility {
  const factory PokemonAbility({
    @HiveField(0) required Species ability,
    @HiveField(1) @JsonKey(name: 'is_hidden') required bool isHidden,
    @HiveField(2) required int slot,
  }) = _PokemonAbility;

  factory PokemonAbility.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityFromJson(json);
}

@freezed
@HiveType(typeId: 5)
abstract class Species with _$Species {
  const factory Species({
    @HiveField(0) required String name,
    @HiveField(1) required String url,
  }) = _Species;

  factory Species.fromJson(Map<String, dynamic> json) =>
      _$SpeciesFromJson(json);
}
