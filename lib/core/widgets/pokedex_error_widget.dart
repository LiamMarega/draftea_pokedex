import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PokedexErrorWidget extends StatelessWidget {
  const PokedexErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            SvgPicture.asset(
              'assets/icons/pokeball.svg',
              width: 100,
              height: 100,
            ),
            const Text('Error al cargar la lista de Pokémon'),
          ],
        ),
      ),
    );
  }
}
