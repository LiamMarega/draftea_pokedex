import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
abstract class Pokemon with _$Pokemon {
  const factory Pokemon({
    required String name,
    required String url,
  }) = _Pokemon;
  const Pokemon._();

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.parse(segments.last);
  }
}

@freezed
abstract class PokemonAbility with _$PokemonAbility {
  const factory PokemonAbility({
    required Species ability,
    @JsonKey(name: 'is_hidden') required bool isHidden,
    required int slot,
  }) = _PokemonAbility;

  factory PokemonAbility.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityFromJson(json);
}

@freezed
abstract class Species with _$Species {
  const factory Species({
    required String name,
    required String url,
  }) = _Species;

  factory Species.fromJson(Map<String, dynamic> json) =>
      _$SpeciesFromJson(json);
}
