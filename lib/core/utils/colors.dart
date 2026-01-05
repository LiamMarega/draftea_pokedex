import 'package:flutter/material.dart';

/// Modern Pokédex app color palette - Clean/Glassmorphism style
class PokedexColors {
  // Primary colors
  static const Color primary = Color(0xFF13EC37); // Neon Green
  static const Color primaryLight = Color(0xFF4AFF6B);
  static const Color primaryDark = Color(0xFF0BB82A);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF102213);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x14000000);

  // Text colors
  static const Color textMain = Color(0xFF0D1B10);
  static const Color textPrimary = Color(0xFF0D1B10);
  static const Color textSecondary = Color(0x990D1B10); // 60% opacity
  static const Color textTertiary = Color(0x660D1B10); // 40% opacity

  // Status colors
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);

  // Modern Pokémon type colors (vibrant pastels from HTML design)
  static const Color grass = Color(0xFF48D0B0);
  static const Color fire = Color(0xFFFB6C6C);
  static const Color water = Color(0xFF76BDFE);
  static const Color electric = Color(0xFFFFD86F);
  static const Color bug = Color(0xFFA8B820);
  static const Color normal = Color(0xFFA8A878);
  static const Color poison = Color(0xFFA040A0);
  static const Color ground = Color(0xFFE0C068);
  static const Color fairy = Color(0xFFEE99AC);
  static const Color psychic = Color(0xFFF85888);
  static const Color fighting = Color(0xFFC03028);
  static const Color rock = Color(0xFFB8A038);
  static const Color ghost = Color(0xFF705898);
  static const Color ice = Color(0xFF98D8D8);
  static const Color dragon = Color(0xFF7038F8);
  static const Color dark = Color(0xFF705848);
  static const Color steel = Color(0xFFB8B8D0);
  static const Color flying = Color(0xFFA890F0);

  /// Returns a vibrant color based on the Pokémon type
  static Color getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return grass;
      case 'water':
        return water;
      case 'fire':
        return fire;
      case 'ground':
        return ground;
      case 'electric':
        return electric;
      case 'fairy':
        return fairy;
      case 'psychic':
        return psychic;
      case 'fighting':
        return fighting;
      case 'bug':
        return bug;
      case 'poison':
        return poison;
      case 'rock':
        return rock;
      case 'ghost':
        return ghost;
      case 'ice':
        return ice;
      case 'dragon':
        return dragon;
      case 'dark':
        return dark;
      case 'steel':
        return steel;
      case 'flying':
        return flying;
      case 'normal':
      default:
        return normal;
    }
  }

  /// Returns a lighter/pastel version for card backgrounds
  static Color getCardBackgroundByType(String type) {
    return getColorByType(type).withOpacity(0.2);
  }

  /// Returns a medium opacity version for chips/badges
  static Color getChipColorByType(String type) {
    return getColorByType(type).withOpacity(0.85);
  }
}
