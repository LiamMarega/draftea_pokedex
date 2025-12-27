import 'package:bloc/bloc.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';

import 'package:draftea_pokedex/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'pokedex_cubit.freezed.dart';
part 'pokedex_state.dart';

@injectable
class PokedexCubit extends Cubit<PokedexState> {
  PokedexCubit(this._repository)
    : super(
        PokedexState(
          scrollController: ScrollController(),
        ),
      ) {
    _initScrollListener();
  }

  final IPokemonRepository _repository;

  void _initScrollListener() {
    state.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (state.hasReachedMax) return;
    if (state.scrollController.position.pixels ==
        state.scrollController.position.maxScrollExtent) {
      fetchPokemons();
    }
  }

  Future<void> fetchPokemons() async {
    emit(state.copyWith(status: PokemonListStatus.loading));

    try {
      final response = await _repository.getPokemonList(
        offset: state.currentOffset,
      );
      final newPokemons = await Future.wait(
        response.results.map((r) async {
          final id = int.parse(
            r.url.split('/').where((e) => e.isNotEmpty).last,
          );
          return _repository.getPokemon(id);
        }),
      );

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
