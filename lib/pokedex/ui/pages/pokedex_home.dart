import 'package:draftea_pokedex/core/widgets/pokedex_appbar.dart';
import 'package:draftea_pokedex/core/widgets/pokedex_error_widget.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:draftea_pokedex/pokedex/ui/widgets/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PokedexAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final isDesktop = constraints.maxWidth > 800;

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
              BlocBuilder<PokedexCubit, PokedexState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PokemonListStatus.initial:
                      return const Center(child: CircularProgressIndicator());
                    case PokemonListStatus.loading:
                    case PokemonListStatus.success:
                      if (state.pokemons.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ResponsiveGridListBuilder(
                        horizontalGridMargin: 50,
                        verticalGridMargin: 50,
                        minItemWidth: 300,
                        minItemsPerRow: 2,
                        maxItemsPerRow: 5,
                        gridItems: state.pokemons
                            .map((pokemon) => PokemonCard(pokemon: pokemon))
                            .toList(),
                        builder: (context, items) {
                          return SingleChildScrollView(
                            controller: state.scrollController,
                            child: Column(
                              children: [
                                ...items,
                                if (!state.hasReachedMax)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    case PokemonListStatus.failure:
                      return const Center(child: PokedexErrorWidget());
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
