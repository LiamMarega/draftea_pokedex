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

  /// List of pastel colors for Pokémon cards
  static const List<Color> cardColors = [
    grassLight,
    waterLight,
    fireLight,
    groundLight,
    normalLight,
    electricLight,
    fairyLight,
    psychicLight,
    fightingLight,
    bugLight,
  ];

  /// Returns a pastel color based on the Pokémon ID
  static Color getCardColor(int pokemonId) {
    return cardColors[pokemonId % cardColors.length];
  }
}
