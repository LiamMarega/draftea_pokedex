import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/core/widgets/pokedex_appbar.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:flutter/material.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({
    required this.pokemon,
    required this.id,
    super.key,
  });
  final PokemonDetail pokemon;
  final int id;

  @override
  Widget build(BuildContext context) {
    final baseColor = pokemon.types.isNotEmpty
        ? PokedexColors.getColorByType(pokemon.types.first.type.name)
        : Colors.grey[400]!;

    return Scaffold(
      appBar: PokedexAppBar(
        title: pokemon.displayName,
        showBackButton: true,
        titleStyle: const TextStyle(
          fontFamily: 'PokemonSolid',
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final isDesktop = constraints.maxWidth > 800;

          final imageCard = Container(
            constraints: (isLandscape || isDesktop)
                ? null
                : const BoxConstraints(minHeight: 300),
            child: AspectRatio(
              aspectRatio: (isLandscape || isDesktop) ? 0.8 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withValues(alpha: 0.8),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      baseColor.withValues(alpha: 0.1),
                      baseColor,
                      Colors.white.withValues(alpha: 0.4),
                      baseColor,
                      baseColor.withValues(alpha: 0.9),
                    ],
                    stops: const [0, 0.3, 0.5, 0.7, 1],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.15),
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: 0.15),
                            ],
                            stops: const [0, 0.5, 1],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Hero(
                        tag: 'pokemon-${pokemon.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 48,
                              color: Colors.white,
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

          // Details Info Card Widget
          final detailsCard = Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: (isLandscape || isDesktop)
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                Text(
                  'Abilities',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pokemon.abilities.map((ability) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: ability.isHidden
                            ? Colors.grey[100]
                            : baseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ability.isHidden
                              ? Colors.grey[300]!
                              : baseColor.withValues(alpha: 0.3),
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
                                  ? Colors.grey[700]
                                  : baseColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (ability.isHidden) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.visibility_off_outlined,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                if (pokemon.sprites.frontDefault != null) ...[
                  Text(
                    'Sprites',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _SpriteThumbnail(
                        url: pokemon.sprites.frontDefault!,
                        color: baseColor,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );

          final bottomPadding = MediaQuery.of(context).padding.bottom + 40;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  (isLandscape || isDesktop)
                      ? 'assets/images/pokedex-bg-landscape.png'
                      : 'assets/images/pokedex-bg.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(.7),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: (isLandscape || isDesktop)
                    ? constraints.maxHeight
                    : constraints.maxHeight * 0.45,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: (isLandscape || isDesktop)
                          ? Alignment.centerLeft
                          : Alignment.topCenter,
                      end: (isLandscape || isDesktop)
                          ? Alignment.centerRight
                          : Alignment.bottomCenter,
                      colors: [
                        baseColor.withValues(alpha: 0.8),
                        baseColor.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 24,
                      left: 24,
                      right: 24,
                      bottom: bottomPadding,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: (isLandscape || isDesktop)
                            ? IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: imageCard,
                                    ),
                                    const SizedBox(width: 48),
                                    Expanded(
                                      flex: 6,
                                      child: detailsCard,
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  imageCard,
                                  const SizedBox(height: 32),
                                  detailsCard,
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SpriteThumbnail extends StatelessWidget {
  const _SpriteThumbnail({
    required this.url,
    required this.color,
  });

  final String url;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
      ),
    );
  }
}
