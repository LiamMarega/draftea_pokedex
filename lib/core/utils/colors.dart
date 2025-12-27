import 'package:flutter/material.dart';

/// Pokédex app color palette
class PokedexColors {
  // Primary colors
  static const Color primary = Color(0xFF303943);
  static const Color primaryLight = Color(0xFF505a67);
  static const Color primaryDark = Color(0xFF1a2028);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x14000000); // black with 8% opacity

  // Text colors
  static const Color textPrimary = Color(0xFF303943);
  static const Color textSecondary = Color(0x99303943); // 60% opacity
  static const Color textTertiary = Color(0x66303943); // 40% opacity

  // Status colors
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);

  // Pokémon type pastel colors for cards
  static const Color grassLight = Color(0xFFB8E6C1);
  static const Color waterLight = Color(0xFFB3D9E8);
  static const Color fireLight = Color(0xFFF5D6BA);
  static const Color groundLight = Color(0xFFE8D5B7);
  static const Color normalLight = Color(0xFFE0E0E0);
  static const Color electricLight = Color(0xFFF5E6BA);
  static const Color fairyLight = Color(0xFFE6B8D4);
  static const Color psychicLight = Color(0xFFD4B8E6);
  static const Color fightingLight = Color(0xFFB8C8E6);
  static const Color bugLight = Color(0xFFC8E6B8);
  static const Color poisonLight = Color(0xFFE0B8E6);
  static const Color rockLight = Color(0xFFD5D5B8);
  static const Color ghostLight = Color(0xFFC1B8E6);
  static const Color iceLight = Color(0xFFB8E0E6);
  static const Color dragonLight = Color(0xFFC8B8F5);
  static const Color darkLight = Color(0xFFB8B8B8);
  static const Color steelLight = Color(0xFFB8C1C8);
  static const Color flyingLight = Color(0xFFD9E8F5);

  /// Returns a color based on the Pokémon type
  static Color getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return grassLight;
      case 'water':
        return waterLight;
      case 'fire':
        return fireLight;
      case 'ground':
        return groundLight;
      case 'electric':
        return electricLight;
      case 'fairy':
        return fairyLight;
      case 'psychic':
        return psychicLight;
      case 'fighting':
        return fightingLight;
      case 'bug':
        return bugLight;
      case 'poison':
        return poisonLight;
      case 'rock':
        return rockLight;
      case 'ghost':
        return ghostLight;
      case 'ice':
        return iceLight;
      case 'dragon':
        return dragonLight;
      case 'dark':
        return darkLight;
      case 'steel':
        return steelLight;
      case 'flying':
        return flyingLight;
      case 'normal':
      default:
        return normalLight;
    }
  }
}
