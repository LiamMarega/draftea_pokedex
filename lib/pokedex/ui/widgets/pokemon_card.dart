import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/core/router/route.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    required this.pokemon,
    super.key,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(
          PokedexRoutes.detailPath(pokemon.id),
          extra: pokemon,
        );
      },
      child: Card(
        color: pokemon.types.isNotEmpty
            ? PokedexColors.getColorByType(pokemon.types.first.type.name)
            : Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
              child: Text(
                pokemon.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
