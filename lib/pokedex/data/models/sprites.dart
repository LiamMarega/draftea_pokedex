import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'sprites.freezed.dart';
part 'sprites.g.dart';

@freezed
@HiveType(typeId: 1)
abstract class Sprites with _$Sprites {
  const factory Sprites({
    @HiveField(0) @JsonKey(name: 'front_default') String? frontDefault,
    @HiveField(1) Other? other,
  }) = _Sprites;

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);
}

@freezed
@HiveType(typeId: 2)
abstract class Other with _$Other {
  const factory Other({
    @HiveField(0)
    @JsonKey(name: 'official-artwork')
    OfficialArtwork? officialArtwork,
  }) = _Other;

  factory Other.fromJson(Map<String, dynamic> json) => _$OtherFromJson(json);
}

@freezed
@HiveType(typeId: 3)
abstract class OfficialArtwork with _$OfficialArtwork {
  const factory OfficialArtwork({
    @HiveField(0) @JsonKey(name: 'front_default') String? frontDefault,
  }) = _OfficialArtwork;

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) =>
      _$OfficialArtworkFromJson(json);
}
