import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pokemon details '),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
