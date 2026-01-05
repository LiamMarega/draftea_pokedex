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
  int _selectedNavIndex = 0;

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
                          color: Colors.grey.withOpacity(0.1),
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

              // 2. Modern Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: PokedexColors.textMain,
                      ),
                      decoration: InputDecoration(
                        hintText: 'What Pokémon are you looking for?',
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
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
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
                      return _buildPokemonGrid(state);
                    case PokemonListStatus.success:
                      return _buildPokemonGrid(state);
                    case PokemonListStatus.failure:
                      if (state.pokemons.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: PokedexErrorWidget()),
                        );
                      }
                      return _buildPokemonGrid(state);
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
                        color: Colors.red.withOpacity(0.3),
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

  Widget _buildPokemonGrid(PokedexState state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Show loading indicator at end if more items are available
            if (index >= state.pokemons.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: PokedexColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            final pokemon = state.pokemons[index];
            return PokemonCard(pokemon: pokemon);
          },
          childCount: state.pokemons.length + (state.hasReachedMax ? 0 : 0),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: isActive
                ? BoxDecoration(
                    color: PokedexColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Icon(
              icon,
              color: isActive ? PokedexColors.primary : Colors.grey.shade400,
              size: 24,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: PokedexColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
