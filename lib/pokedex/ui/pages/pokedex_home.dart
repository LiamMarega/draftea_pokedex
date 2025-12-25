import 'package:draftea_pokedex/core/router/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pokedex'),
            ElevatedButton(
              onPressed: () {
                context.go(PokedexRoutes.detail);
              },
              child: const Text('Go to Pokemon Details'),
            ),
          ],
        ),
      ),
    );
  }
}
