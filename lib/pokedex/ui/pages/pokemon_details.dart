import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:flutter/material.dart';

class PokemonDetailsPage extends StatelessWidget {
  final PokemonDetail pokemon;
  final int id;

  const PokemonDetailsPage({
    required this.pokemon,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pokemon.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              pokemon.formattedId,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pokemon Image with Hero Animation
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(32),
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Basic Info Header
            Text(
              'Abilities',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Abilities List
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pokemon.abilities.map((ability) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ability.isHidden
                        ? Colors.blueGrey[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ability.isHidden
                          ? Colors.blueGrey[100]!
                          : Colors.blue[100]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ability.ability.name[0].toUpperCase() +
                            ability.ability.name.substring(1),
                        style: TextStyle(
                          color: ability.isHidden
                              ? Colors.blueGrey[700]
                              : Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (ability.isHidden) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.visibility_off_outlined,
                          size: 14,
                          color: Colors.blueGrey[400],
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // More Sprites Section (if available)
            if (pokemon.sprites.frontDefault != null) ...[
              Text(
                'Sprites',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _SpriteThumbnail(url: pokemon.sprites.frontDefault!),
                  // Add more sprites here if available in the model in the future
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpriteThumbnail extends StatelessWidget {
  const _SpriteThumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
      ),
    );
  }
}
