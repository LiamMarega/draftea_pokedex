import 'package:draftea_pokedex/core/router/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return const Text('Pokemon');
        },
      ),
    );
  }
}
