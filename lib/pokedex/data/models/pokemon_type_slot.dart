import 'package:draftea_pokedex/pokedex/domain/entities/pokemon_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'pokemon_type_slot.freezed.dart';
part 'pokemon_type_slot.g.dart';

@freezed
@HiveType(typeId: 6)
abstract class PokemonTypeSlot with _$PokemonTypeSlot {
  const factory PokemonTypeSlot({
    @HiveField(0) required int slot,
    @HiveField(1) required PokemonTypeInfo type,
  }) = _PokemonTypeSlot;

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotFromJson(json);

  const PokemonTypeSlot._();
}

@freezed
@HiveType(typeId: 7)
abstract class PokemonTypeInfo with _$PokemonTypeInfo {
  const factory PokemonTypeInfo({
    @HiveField(0) required String name,
    @HiveField(1) required String url,
  }) = _PokemonTypeInfo;

  factory PokemonTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeInfoFromJson(json);

  const PokemonTypeInfo._();

  PokemonType get typeEnum => PokemonType.fromString(name);
}
