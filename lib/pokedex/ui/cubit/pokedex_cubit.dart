import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    _initConnectivityListener();
  }

  final IPokemonRepository _repository;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectivity,
    );
    // Check initial state
    Connectivity().checkConnectivity().then(_updateConnectivity);
  }

  void _updateConnectivity(List<ConnectivityResult> results) {
    final isOffline = results.contains(ConnectivityResult.none);
    emit(state.copyWith(isOffline: isOffline));
  }

  void _initScrollListener() {
    state.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (state.hasReachedMax || state.isOffline) return;
    if (state.scrollController.position.pixels ==
        state.scrollController.position.maxScrollExtent) {
      fetchPokemons();
    }
  }

  Future<void> fetchPokemons() async {
    if (state.isOffline && state.pokemons.isNotEmpty) return;

    if (state.pokemons.isEmpty) {
      emit(state.copyWith(status: PokemonListStatus.loading));
    }

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
      if (state.pokemons.isNotEmpty) {
        // Keep explicit status but show error in UI/logs?
        // Or just don't emit failure to prevent screen replacement
        emit(state.copyWith(errorMessage: e.toString()));
      } else {
        emit(
          state.copyWith(
            status: PokemonListStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    state.scrollController.dispose();
    return super.close();
  }
}
