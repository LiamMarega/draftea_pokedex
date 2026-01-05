import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/core/router/route.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonCard extends StatefulWidget {
  const PokemonCard({
    required this.pokemon,
    super.key,
  });

  final PokemonDetail pokemon;

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    final typeName =
        pokemon.types.isNotEmpty ? pokemon.types.first.type.name : 'normal';
    final color = PokedexColors.getColorByType(typeName);

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        context.push(PokedexRoutes.detailPath(pokemon.id), extra: pokemon);
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            // Glassmorphism: pastel background with type color
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // --- LAYER 1: Giant ID Decoration ---
              Positioned(
                right: -5,
                top: -5,
                child: Text(
                  pokemon.formattedId,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: color.withOpacity(0.15),
                    height: 1,
                  ),
                ),
              ),

              // --- LAYER 2: White circle decoration ---
              Positioned(
                bottom: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // --- LAYER 3: Content (Name + Type Chips) ---
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pokemon Name
                    Text(
                      pokemon.displayName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: PokedexColors.textMain,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Type Chips (vertical)
                    ...pokemon.types.take(2).map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: PokedexColors.getChipColorByType(
                                  t.type.name,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                t.type.name,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),

              // --- LAYER 4: Pokemon Image with Hero ---
              Positioned(
                bottom: 8,
                right: 8,
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      height: 90,
                      width: 90,
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 90,
                      width: 90,
                      child: Icon(
                        Icons.catching_pokemon,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
