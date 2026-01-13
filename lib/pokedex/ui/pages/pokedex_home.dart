import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/core/utils/responsive_grid.dart';
import 'package:draftea_pokedex/core/widgets/pokedex_error_widget.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:draftea_pokedex/pokedex/ui/widgets/pokemon_card.dart';
import 'package:draftea_pokedex/pokedex/ui/widgets/pokemon_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PokedexHomePage extends StatefulWidget {
  const PokedexHomePage({super.key});

  @override
  State<PokedexHomePage> createState() => _PokedexHomePageState();
}

class _PokedexHomePageState extends State<PokedexHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PokedexColors.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            controller: context.read<PokedexCubit>().state.scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
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
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchHeaderDelegate(
                  topPadding: MediaQuery.of(context).padding.top,
                  minHeight: 30 + MediaQuery.of(context).padding.top,
                  maxHeight: 50,
                  searchController: _searchController,
                  onSearchChanged: context.read<PokedexCubit>().onSearchChanged,
                  onClear: () {
                    _searchController.clear();
                    context.read<PokedexCubit>().clearSearch();
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              BlocBuilder<PokedexCubit, PokedexState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PokemonListStatus.initial:
                    case PokemonListStatus.loading:
                      if (state.pokemons.isEmpty) {
                        return _buildSkeletonGrid(context);
                      }
                      return _buildGridContainer(context, state, true);
                    case PokemonListStatus.success:
                      return _buildGridContainer(
                        context,
                        state,
                        !state.hasReachedMax,
                      );
                    case PokemonListStatus.failure:
                      if (state.pokemons.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: PokedexErrorWidget()),
                        );
                      }
                      return _buildGridContainer(context, state, false);
                  }
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
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

  Widget _buildSkeletonGrid(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columnCount = ResponsiveGrid.getColumnCount(width);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: ResponsiveGrid.getDelegate(width),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const PokemonCardSkeleton(),
          childCount: columnCount * 3,
        ),
      ),
    );
  }

  Widget _buildGridContainer(
    BuildContext context,
    PokedexState state,
    bool showLoader,
  ) {
    final cubit = context.read<PokedexCubit>();
    final pokemons = cubit.filteredPokemons;

    if (pokemons.isEmpty && state.searchQuery.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No se encontraron Pokémon',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverMainAxisGroup(
        slivers: [
          _buildPokemonGrid(context, pokemons),
          if (showLoader && state.searchQuery.isEmpty)
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

  Widget _buildPokemonGrid(
    BuildContext context,
    List<PokemonDetail> pokemons,
  ) {
    final width = MediaQuery.of(context).size.width;
    return SliverGrid(
      gridDelegate: ResponsiveGrid.getDelegate(width),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final pokemon = pokemons[index];
          return PokemonCard(pokemon: pokemon);
        },
        childCount: pokemons.length,
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SearchHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.topPadding,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClear,
  });

  final double minHeight;
  final double maxHeight;
  final double topPadding;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;

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
          controller: searchController,
          onChanged: onSearchChanged,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: PokedexColors.textMain,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar Pokémon...',
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.grey.shade400,
            ),
            suffixIcon: BlocSelector<PokedexCubit, PokedexState, String>(
              selector: (state) => state.searchQuery,
              builder: (context, query) {
                if (query.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: onClear,
                );
              },
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
