import 'package:draftea_pokedex/pokedex/ui/pages/pokedex_home.dart';
import 'package:draftea_pokedex/pokedex/ui/pages/pokemon_details.dart';
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
      builder: (context, state) => const PokemonDetailsPage(),
    ),
  ],
);
