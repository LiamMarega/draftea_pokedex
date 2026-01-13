import 'package:draftea_pokedex/pokedex/domain/entities/pokemon_type.dart';
import 'package:equatable/equatable.dart';

/// Domain entity representing a Pokemon.
/// This is a pure domain model, independent of data layer implementations.
class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.stats,
    required this.sprites,
    required this.height,
    required this.weight,
    required this.abilities,
    this.baseExperience,
  });

  final int id;
  final String name;
  final List<PokemonType> types;
  final PokemonStats stats;
  final PokemonSprites sprites;
  final int height; // in decimeters
  final int weight; // in hectograms
  final List<PokemonAbilityInfo> abilities;
  final int? baseExperience;

  /// Get the display name (capitalized)
  String get displayName => name[0].toUpperCase() + name.substring(1);

  /// Get the formatted Pokemon ID (e.g., #001)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  /// Get the primary type
  PokemonType get primaryType =>
      types.isNotEmpty ? types.first : PokemonType.unknown;

  /// Get the best available image URL
  String get imageUrl =>
      sprites.officialArtwork ??
      sprites.frontDefault ??
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  /// Height in meters
  double get heightInMeters => height / 10;

  /// Weight in kilograms
  double get weightInKg => weight / 10;

  @override
  List<Object?> get props => [
    id,
    name,
    types,
    stats,
    sprites,
    height,
    weight,
    abilities,
    baseExperience,
  ];
}

/// Pokemon statistics
class PokemonStats extends Equatable {
  const PokemonStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  /// Get the total of all stats
  int get total =>
      hp + attack + defense + specialAttack + specialDefense + speed;

  /// Get the maximum stat value (for progress bars)
  static const int maxStatValue = 255;

  @override
  List<Object?> get props => [
    hp,
    attack,
    defense,
    specialAttack,
    specialDefense,
    speed,
  ];
}

/// Pokemon sprite URLs
class PokemonSprites extends Equatable {
  const PokemonSprites({
    this.frontDefault,
    this.backDefault,
    this.frontShiny,
    this.backShiny,
    this.officialArtwork,
    this.dreamWorld,
  });

  final String? frontDefault;
  final String? backDefault;
  final String? frontShiny;
  final String? backShiny;
  final String? officialArtwork;
  final String? dreamWorld;

  @override
  List<Object?> get props => [
    frontDefault,
    backDefault,
    frontShiny,
    backShiny,
    officialArtwork,
    dreamWorld,
  ];
}

/// Pokemon ability information
class PokemonAbilityInfo extends Equatable {
  const PokemonAbilityInfo({
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  final String name;
  final bool isHidden;
  final int slot;

  /// Get the display name (capitalized)
  String get displayName => name[0].toUpperCase() + name.substring(1);

  @override
  List<Object?> get props => [name, isHidden, slot];
}
