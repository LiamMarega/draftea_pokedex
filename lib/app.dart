import 'package:draftea_pokedex/core/router/route.dart';
import 'package:draftea_pokedex/core/utils/colors.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PokedexCubit>()..fetchPokemons(),
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          // Global font configuration
          textTheme: GoogleFonts.plusJakartaSansTextTheme(),
          // Primary color scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: PokedexColors.primary,
          ),
          // Scaffold background
          scaffoldBackgroundColor: PokedexColors.backgroundLight,
          // AppBar theme (for fallback)
          appBarTheme: AppBarTheme(
            backgroundColor: PokedexColors.backgroundLight,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: PokedexColors.textMain,
            ),
          ),
          // Remove scroll glow
          scrollbarTheme: const ScrollbarThemeData(
            thumbVisibility: WidgetStatePropertyAll(false),
          ),
        ),
      ),
    );
  }
}
