import 'package:bloc/bloc.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/sprites.dart';
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
      );

  final IPokemonRepository _repository;

  Future<void> fetchPokemons() async {
    emit(state.copyWith(status: PokemonListStatus.loading));

    try {
      final response = await _repository.getPokemonList();
      final newPokemons = response.results
          .map(
            (r) => PokemonDetail(
              id: int.parse(r.url.split('/').where((e) => e.isNotEmpty).last),
              name: r.name,
              sprites: Sprites(
                frontDefault:
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${r.url.split('/').where((e) => e.isNotEmpty).last}.png',
              ),
              abilities: [],
            ),
          )
          .toList();

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
