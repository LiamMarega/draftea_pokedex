import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
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
        final id = int.parse(state.pathParameters['id']!);
        final pokemon = state.extra as PokemonDetail?;
        if (pokemon == null) {
          return const Scaffold(
            body: Center(child: Text('Pokemon not found')),
          );
        }
        return PokemonDetailsPage(id: pokemon.id, pokemon: pokemon);
      },
    ),
  ],
);
