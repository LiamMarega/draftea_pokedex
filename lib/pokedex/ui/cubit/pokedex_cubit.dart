import 'package:bloc/bloc.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokedex_state.dart';
part 'pokedex_cubit.freezed.dart';

class PokedexCubit extends Cubit<PokedexState> {
  PokedexCubit()
    : super(
        PokedexState(
          scrollController: ScrollController(),
        ),
      );

  // Ejemplo de cómo usar el estado:
  Future<void> fetchPokemons() async {
    // 1. Cambiar a estado de carga manteniendo los pokemons actuales
    emit(state.copyWith(status: PokemonListStatus.loading));

    try {
      // Supongamos que traes una lista de pokemons
      final newPokemons = <PokemonDetail>[]; // Tu lógica de API aquí

      // 2. Actualizar con éxito
      emit(
        state.copyWith(
          status: PokemonListStatus.success,
          pokemons: [...state.pokemons, ...newPokemons],
          currentOffset: state.currentOffset + 20,
          hasReachedMax: newPokemons.isEmpty,
        ),
      );
    } catch (e) {
      // 3. Manejar error
      emit(
        state.copyWith(
          status: PokemonListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    state.scrollController.dispose();
    return super.close();
  }
}
