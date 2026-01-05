import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_stat.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({
    required this.pokemon,
    required this.id,
    super.key,
  });

  final PokemonDetail pokemon;
  final int id;

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    final baseColor = pokemon.types.isNotEmpty
        ? PokedexColors.getColorByType(pokemon.types.first.type.name)
        : Colors.grey;
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.42;

    return Scaffold(
      backgroundColor: baseColor,
      body: Stack(
        children: [
          // --- LAYER 1: Colored Header Background ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: const Stack(
                children: [
                  // Background decorative pokeball
                  Positioned(
                    right: -50,
                    bottom: 0,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.catching_pokemon,
                        size: 200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- LAYER 2: Top Navigation (Back + Favorite) ---
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GlassButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => context.pop(),
                ),
                _GlassButton(
                  icon: Icons.favorite_outline_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // --- LAYER 3: White Content Sheet ---
          Positioned(
            top: headerHeight - 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 70, // Space for overlapping image
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  children: [
                    // Pokemon Name
                    Text(
                      pokemon.displayName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: PokedexColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Pokemon ID
                    Text(
                      pokemon.formattedId,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Type Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pokemon.types.map((typeSlot) {
                        final typeName = typeSlot.type.name;
                        final color = PokedexColors.getColorByType(typeName);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            typeName,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Tabs (About / Stats)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'About'),
                          Tab(text: 'Stats'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tab Content
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // About Tab
                          _AboutTab(pokemon: pokemon, baseColor: baseColor),
                          // Stats Tab
                          _StatsTab(pokemon: pokemon),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- LAYER 4: Floating Pokemon Image (Hero) ---
          Positioned(
            top: headerHeight - 240,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 5,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    height: 220,
                    width: 220,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      height: 180,
                      width: 180,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.catching_pokemon,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass-style button for navigation
class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

/// About Tab content
class _AboutTab extends StatelessWidget {
  const _AboutTab({
    required this.pokemon,
    required this.baseColor,
  });

  final PokemonDetail pokemon;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weight & Height Row
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.fitness_center_rounded,
                  value: '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
                  label: 'Weight',
                  color: baseColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricCard(
                  icon: Icons.straighten_rounded,
                  value: '${(pokemon.height / 10).toStringAsFixed(1)} m',
                  label: 'Height',
                  color: baseColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Abilities Section
          Text(
            'Abilities',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PokedexColors.textMain,
            ),
          ),
          const SizedBox(height: 12),
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
                      ? Colors.grey.shade100
                      : baseColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ability.isHidden
                        ? Colors.grey.shade300
                        : baseColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ability.ability.name[0].toUpperCase() +
                          ability.ability.name.substring(1),
                      style: GoogleFonts.plusJakartaSans(
                        color: PokedexColors.textMain,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (ability.isHidden) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.visibility_off_outlined,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),

          // Sprites Section
          if (pokemon.sprites.frontDefault != null) ...[
            const SizedBox(height: 24),
            Text(
              'Sprites',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: PokedexColors.textMain,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _SpriteThumbnail(
                  url: pokemon.sprites.frontDefault!,
                  label: 'Default',
                  color: baseColor,
                ),
                if (pokemon.sprites.other?.officialArtwork?.frontDefault !=
                    null) ...[
                  const SizedBox(width: 12),
                  _SpriteThumbnail(
                    url: pokemon.sprites.other!.officialArtwork!.frontDefault!,
                    label: 'Official',
                    color: baseColor,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Stats Tab content with animated bars
class _StatsTab extends StatelessWidget {
  const _StatsTab({required this.pokemon});

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Base Stats',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PokedexColors.textMain,
            ),
          ),
          const SizedBox(height: 16),
          ...pokemon.stats.map(
            (stat) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AnimatedStatBar(stat: stat),
            ),
          ),
        ],
      ),
    );
  }
}

/// Metric card for weight/height
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: PokedexColors.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated stat bar with progress fill
class _AnimatedStatBar extends StatefulWidget {
  const _AnimatedStatBar({required this.stat});

  final PokemonStat stat;

  @override
  State<_AnimatedStatBar> createState() => _AnimatedStatBarState();
}

class _AnimatedStatBarState extends State<_AnimatedStatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _getShortName(widget.stat.stat?.name ?? '');
    final value = widget.stat.baseStat ?? 0;
    final maxValue = 255;
    final progress = value / maxValue;
    final color = _getStatColor(name);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                style: GoogleFonts.plusJakartaSans(
                  color: PokedexColors.textMain,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Animated progress bar
                  FractionallySizedBox(
                    widthFactor: (progress * _animation.value).clamp(0.0, 1.0),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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

  Color _getStatColor(String name) {
    switch (name) {
      case 'HP':
        return const Color(0xFFFF5959);
      case 'ATK':
        return const Color(0xFFF5AC78);
      case 'DEF':
        return const Color(0xFFFAE078);
      case 'SATK':
        return const Color(0xFF9DB7F5);
      case 'SDEF':
        return const Color(0xFFA7DB8D);
      case 'SPD':
        return const Color(0xFFFA92B2);
      default:
        return Colors.grey;
    }
  }
}

/// Sprite thumbnail widget
class _SpriteThumbnail extends StatelessWidget {
  const _SpriteThumbnail({
    required this.url,
    required this.label,
    required this.color,
  });

  final String url;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: CachedNetworkImage(
            imageUrl: url,
            height: 60,
            width: 60,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
