import 'package:freezed_annotation/freezed_annotation.dart';

part 'sprites.freezed.dart';
part 'sprites.g.dart';

@freezed
abstract class Sprites with _$Sprites {
  const factory Sprites({
    @JsonKey(name: 'front_default') String? frontDefault,
    Other? other,
  }) = _Sprites;

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);
}

@freezed
abstract class Other with _$Other {
  const factory Other({
    @JsonKey(name: 'official-artwork') OfficialArtwork? officialArtwork,
  }) = _Other;

  factory Other.fromJson(Map<String, dynamic> json) => _$OtherFromJson(json);
}

@freezed
abstract class OfficialArtwork with _$OfficialArtwork {
  const factory OfficialArtwork({
    @JsonKey(name: 'front_default') String? frontDefault,
  }) = _OfficialArtwork;

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) =>
      _$OfficialArtworkFromJson(json);
}
