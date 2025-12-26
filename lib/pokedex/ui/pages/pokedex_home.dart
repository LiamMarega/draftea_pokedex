import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PokedexCubit, PokedexState>(
        builder: (context, state) {
          switch (state.status) {
            case PokemonListStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case PokemonListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PokemonListStatus.success:
              return ResponsiveGridListBuilder(
                horizontalGridMargin: 50,
                verticalGridMargin: 50,
                minItemWidth: 300,
                minItemsPerRow: 2,
                maxItemsPerRow: 5,
                gridItems: state.pokemons.map((e) => Text(e.name)).toList(),
                builder: (context, items) {
                  return SingleChildScrollView(
                    controller: state.scrollController,
                    child: Column(
                      children: items,
                    ),
                  );
                },
              );
            case PokemonListStatus.failure:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        },
      ),
    );
  }
}
