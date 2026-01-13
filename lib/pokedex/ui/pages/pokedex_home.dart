import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/core/widgets/pokedex_error_widget.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:draftea_pokedex/pokedex/ui/widgets/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PokedexHomePage extends StatefulWidget {
  const PokedexHomePage({super.key});

  @override
  State<PokedexHomePage> createState() => _PokedexHomePageState();
}

class _PokedexHomePageState extends State<PokedexHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PokedexColors.backgroundLight,
      body: Stack(
        children: [
          // Main Scrollable Content
          CustomScrollView(
            controller: context.read<PokedexCubit>().state.scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // 1. Custom Header (Title + Settings Button)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    MediaQuery.of(context).padding.top + 20,
                    24,
                    16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pokedex',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: PokedexColors.textMain,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: PokedexColors.textMain,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Sticky Search Bar
              SliverPersistentHeader(
                pinned: true,

                delegate: _SearchHeaderDelegate(
                  topPadding: MediaQuery.of(context).padding.top,
                  minHeight: 30 + MediaQuery.of(context).padding.top,
                  maxHeight: 50,
                ),
              ),

              // 3. Spacer
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),

              // 4. Pokemon Grid
              BlocBuilder<PokedexCubit, PokedexState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PokemonListStatus.initial:
                    case PokemonListStatus.loading:
                      if (state.pokemons.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: PokedexColors.primary,
                            ),
                          ),
                        );
                      }
                      return _buildGridContainer(state, true);
                    case PokemonListStatus.success:
                      return _buildGridContainer(state, !state.hasReachedMax);
                    case PokemonListStatus.failure:
                      if (state.pokemons.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: PokedexErrorWidget()),
                        );
                      }
                      return _buildGridContainer(state, false);
                  }
                },
              ),

              // 5. Bottom padding for floating nav bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),

          // Offline Banner
          BlocSelector<PokedexCubit, PokedexState, bool>(
            selector: (state) => state.isOffline,
            builder: (context, isOffline) {
              if (!isOffline) return const SizedBox.shrink();
              return Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Modo Offline',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridContainer(PokedexState state, bool showLoader) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverMainAxisGroup(
        slivers: [
          _buildPokemonGrid(state),
          if (showLoader)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: CircularProgressIndicator(
                    color: PokedexColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPokemonGrid(PokedexState state) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 1.2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final pokemon = state.pokemons[index];
          return PokemonCard(pokemon: pokemon);
        },
        childCount: state.pokemons.length,
      ),
    );
  }
}

/// Delegate for the sticky search header with SafeArea support
class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SearchHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.topPadding,
  });

  final double minHeight;
  final double maxHeight;
  final double topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: PokedexColors.backgroundLight,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: (query) {
            // TODO: Implement search functionality
            // context.read<PokedexCubit>().onSearchChanged(query);
          },
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: PokedexColors.textMain,
          ),
          decoration: InputDecoration(
            hintText: 'Search Pokémon...',
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.grey.shade400,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => minHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        topPadding != oldDelegate.topPadding;
  }
}
