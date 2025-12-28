import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/core/widgets/pokedex_appbar.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_stat.dart';
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
                // Types
                Center(
                  child: Wrap(
                    spacing: 16,
                    children: pokemon.types.map((typeSlot) {
                      final typeName = typeSlot.type.name;
                      final color = PokedexColors.getColorByType(typeName);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          typeName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Weight & Height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _PokemonMetric(
                      value: '${(pokemon.weight / 10).toStringAsFixed(1)} KG',
                      label: 'Weight',
                    ),
                    _PokemonMetric(
                      value: '${(pokemon.height / 10).toStringAsFixed(1)} M',
                      label: 'Height',
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Base Stats
                const Text(
                  'Base Stats',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...pokemon.stats.map((stat) => _StatRow(stat: stat)).toList(),
                const SizedBox(height: 24),

                Text(
                  'Abilities',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
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
                            ? Colors.white.withValues(alpha: 0.1)
                            : baseColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ability.isHidden
                              ? Colors.white.withValues(alpha: 0.3)
                              : baseColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ability.ability.name[0].toUpperCase() +
                                ability.ability.name.substring(1),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (ability.isHidden) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.visibility_off_outlined,
                              size: 16,
                              color: Colors.black.withValues(alpha: 0.6),
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
                      color: Colors.black,
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
                        borderColor: Colors.white.withValues(alpha: 0.3),
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

class _PokemonMetric extends StatelessWidget {
  const _PokemonMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stat});

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    final name = _getShortName(stat.stat?.name ?? '');
    final value = stat.baseStat ?? 0;
    final max =
        300; // Expected max for base stats usually around 255 but scaling to 300 looks good
    final progress = value / max;

    Color progressColor;
    if (value < 50) {
      progressColor = Colors.red;
    } else if (value < 100) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    // Explicit colors based on design if needed, but dynamic is good.
    // Design has: HP Red, ATK Orange, DEF Blue, SPD Blue-ish, EXP Green.
    if (name == 'HP') progressColor = const Color(0xFFF7802A); // Red/Orange
    if (name == 'ATK') progressColor = const Color(0xFFF5AC78); // Yellow/Orange
    if (name == 'DEF') progressColor = const Color(0xFF9DB7F5); // Blue
    if (name == 'SPD') progressColor = const Color(0xFFA7DB8D); // Greenish
    if (name == 'EXP') progressColor = const Color(0xFFFA92B2); // Pinkish?

    // Let's stick to a simpler mapping or just use the dynamic one,
    // but the design image has specific colors.
    // HP: Red
    // ATK: Orange
    // DEF: Blue
    // SPD: Light Blue
    // EXP: Green

    switch (name) {
      case 'HP':
        progressColor = Colors.redAccent;
        break;
      case 'ATK':
        progressColor = Colors.orangeAccent;
        break;
      case 'DEF':
        progressColor = Colors.blueAccent;
        break;
      case 'SPD':
        progressColor = Colors.lightBlueAccent;
        break;
      case 'EXP':
        progressColor = Colors.greenAccent;
        break;
      default:
        progressColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              name,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 12, // Thicker bar
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 4),
                  ),
                ),
                // Text inside the bar usually? Or center?
                // Design shows text "168/300" inside the bar.
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '$value/$max',
                      style: const TextStyle(
                        color: Colors
                            .black54, // Or white if bar is dark? Inner text seems small.
                        // Actually looking at reference image 3: text is INSIDE the red bar part or white part?
                        // It seems to be simply centered or aligned.
                        // Let's put it centered for now.
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getShortName(String name) {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'special-attack':
        return 'SATK';
      case 'special-defense':
        return 'SDEF';
      case 'speed':
        return 'SPD';
      default:
        return name.toUpperCase();
    }
  }
}

class _SpriteThumbnail extends StatelessWidget {
  const _SpriteThumbnail({
    required this.url,
    required this.color,
    this.borderColor,
  });

  final String url;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? color.withValues(alpha: 0.2)),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
      ),
    );
  }
}
