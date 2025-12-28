import 'package:draftea_pokedex/core/router/route.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PokedexCubit>()..fetchPokemons(),

      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
