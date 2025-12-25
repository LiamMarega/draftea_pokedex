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

  Future<void> fetchPokemons() async {
    emit(state.copyWith(status: PokemonListStatus.loading));

    try {
      final newPokemons = <PokemonDetail>[];

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
