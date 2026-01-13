import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';
import 'package:draftea_pokedex/pokedex/ui/pages/pokedex_home.dart';
import 'package:draftea_pokedex/pokedex/ui/pages/pokemon_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PokedexRoutes {
  static const String home = '/';
  static const String detail = '/pokemon/:id';

  static String detailPath(int id) => '/pokemon/$id';
}

final router = GoRouter(
  initialLocation: PokedexRoutes.home,
  routes: [
    GoRoute(
      path: PokedexRoutes.home,
      builder: (context, state) => const PokedexHomePage(),
    ),
    GoRoute(
      path: PokedexRoutes.detail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        // Cast to Domain Entity 'Pokemon' instead of Data Model 'PokemonDetail'
        final pokemon = state.extra as Pokemon?;

        if (pokemon == null) {
          // TODO: Fetch pokemon by ID if extra is null (deep linking support)
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Pokemon $id not found or loaded')),
          );
        }
        return PokemonDetailsPage(id: pokemon.id, pokemon: pokemon);
      },
    ),
  ],
);
