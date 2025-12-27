import 'package:draftea_pokedex/pokedex/domain/entities/pokemon_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_type_slot.freezed.dart';
part 'pokemon_type_slot.g.dart';

@freezed
abstract class PokemonTypeSlot with _$PokemonTypeSlot {
  const factory PokemonTypeSlot({
    required int slot,
    required PokemonTypeInfo type,
  }) = _PokemonTypeSlot;

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotFromJson(json);

  const PokemonTypeSlot._();
}

@freezed
abstract class PokemonTypeInfo with _$PokemonTypeInfo {
  const factory PokemonTypeInfo({
    required String name,
    required String url,
  }) = _PokemonTypeInfo;

  factory PokemonTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeInfoFromJson(json);

  const PokemonTypeInfo._();

  PokemonType get typeEnum => PokemonType.fromString(name);
}
