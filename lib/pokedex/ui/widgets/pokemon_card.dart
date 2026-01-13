import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/core/router/route.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    required this.pokemon,
    super.key,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    final typeName = pokemon.types.isNotEmpty
        ? pokemon.types.first.type.name
        : 'normal';
    final color = PokedexColors.getColorByType(typeName);

    return GestureDetector(
      onTap: () => context.push(
        PokedexRoutes.detailPath(pokemon.id),
        extra: pokemon,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 3,
              top: -5,
              child: Text(
                pokemon.formattedId,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 55,
                  fontWeight: FontWeight.w900,
                  color: color.withValues(alpha: 0.15),
                  height: 1,
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  ...pokemon.types
                      .take(2)
                      .map(
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
    );
  }
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage({
    required this.url,
    required this.size,
  });

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: size,
      width: size,
      fit: BoxFit.contain,
      cacheHeight: kIsWeb ? null : (size * 2).toInt(),
      cacheWidth: kIsWeb ? null : (size * 2).toInt(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: size,
          width: size,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: PokedexColors.primary.withValues(alpha: 0.5),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => SizedBox(
        height: size,
        width: size,
        child: const Icon(
          Icons.catching_pokemon,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
