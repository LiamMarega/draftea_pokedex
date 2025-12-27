import 'package:draftea_pokedex/core/widgets/error_widget.dart';
import 'package:draftea_pokedex/pokedex/ui/cubit/pokedex_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokedexErrorWidget extends StatelessWidget {
  const PokedexErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AppErrorWidget(
        title: '¡Problemas en la Pokédex!',
        message:
            'No pudimos conectar con el servidor para obtener los Pokémon. ¿Quizás el Team Rocket está interfiriendo?',
        onRetry: () {
          context.read<PokedexCubit>().fetchPokemons();
        },
        icon: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/psyduck_error.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
