import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/core/utils/responsive_grid.dart';
import 'package:draftea_pokedex/core/widgets/pokedex_error_widget.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:draftea_pokedex/pokedex/ui/widgets/pokemon_card.dart';
import 'package:draftea_pokedex/pokedex/ui/widgets/pokemon_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({super.key});

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
                    24,
                  ),
                  child: Text(
                    'Pokedex',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: PokedexColors.textMain,
                    ),
                  ),
                ),
              ),
              BlocBuilder<PokedexCubit, PokedexState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PokemonListStatus.initial:
                    case PokemonListStatus.loading:
                      if (state.pokemons.isEmpty) {
                        return _buildSkeletonGrid(context, 20);
                      }
                      return _buildMixedGrid(context, state);
                    case PokemonListStatus.success:
                      return _buildMixedGrid(context, state);
                    case PokemonListStatus.failure:
                      if (state.pokemons.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: PokedexErrorWidget()),
                        );
                      }
                      return _buildPokemonGrid(context, state);
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

  Widget _buildSkeletonGrid(BuildContext context, int count) {
    final width = MediaQuery.of(context).size.width;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: ResponsiveGrid.getDelegate(width),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const RepaintBoundary(
            child: PokemonCardSkeleton(),
          ),
          childCount: count,
        ),
      ),
    );
  }

  Widget _buildMixedGrid(BuildContext context, PokedexState state) {
    final width = MediaQuery.of(context).size.width;
    final cubit = context.read<PokedexCubit>();
    final pokemons = state.pokemons;
    final skeletonCount = cubit.remainingSkeletons;
    final totalCount = pokemons.length + skeletonCount;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: ResponsiveGrid.getDelegate(width),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < pokemons.length) {
              return RepaintBoundary(
                child: PokemonCard(pokemon: pokemons[index]),
              );
            }
            return const RepaintBoundary(
              child: PokemonCardSkeleton(),
            );
          },
          childCount: totalCount,
        ),
      ),
    );
  }

  Widget _buildPokemonGrid(BuildContext context, PokedexState state) {
    final width = MediaQuery.of(context).size.width;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: ResponsiveGrid.getDelegate(width),
        delegate: SliverChildBuilderDelegate(
          (context, index) => RepaintBoundary(
            child: PokemonCard(pokemon: state.pokemons[index]),
          ),
          childCount: state.pokemons.length,
        ),
      ),
    );
  }
}
