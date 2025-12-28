import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'pokemon_stat.freezed.dart';
part 'pokemon_stat.g.dart';

@freezed
@HiveType(typeId: 11)
abstract class PokemonStat with _$PokemonStat {
  const factory PokemonStat({
    @HiveField(0) @JsonKey(name: 'base_stat') required int? baseStat,
    @HiveField(1) required int? effort,
    @HiveField(2)
    required Stat?
    stat, // Made nullable just in case, though API usually sends it
  }) = _PokemonStat;

  factory PokemonStat.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatFromJson(json);
}

@freezed
@HiveType(typeId: 12)
abstract class Stat with _$Stat {
  const factory Stat({
    @HiveField(0) required String name,
    @HiveField(1) required String url,
  }) = _Stat;

  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);
}
