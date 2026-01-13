import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:draftea_pokedex/core/utils/batch_executor.dart';
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

  static const int _batchSize = 5;
  static const int _pageSize = 20;

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectivity,
    );
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
    final maxScroll = state.scrollController.position.maxScrollExtent;
    final currentScroll = state.scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      fetchPokemons();
    }
  }

  int get remainingSkeletons {
    if (state.expectedCount == 0) return _pageSize;
    final remaining = state.expectedCount - state.pokemons.length;
    return remaining > 0 ? remaining : 0;
  }

  bool _isFetching = false;

  Future<void> fetchPokemons() async {
    if (_isFetching || state.hasReachedMax) return;
    if (state.isOffline && state.pokemons.isNotEmpty) return;

    _isFetching = true;
    if (state.pokemons.isEmpty) {
      emit(state.copyWith(status: PokemonListStatus.loading));
    }

    try {
      final response = await _repository.getPokemonList(
        offset: state.currentOffset,
      );

      final newExpectedCount = state.expectedCount + response.results.length;
      emit(state.copyWith(expectedCount: newExpectedCount));

      final ids = response.results.map((r) {
        return int.parse(r.url.split('/').where((e) => e.isNotEmpty).last);
      }).toList();

      final newPokemons = await BatchExecutor.execute<PokemonDetail>(
        tasks: ids
            .map(
              (id) =>
                  () => _repository.getPokemon(id),
            )
            .toList(),
      );

      emit(
        state.copyWith(
          status: PokemonListStatus.success,
          pokemons: [...state.pokemons, ...newPokemons],
          currentOffset: state.currentOffset + _pageSize,
          hasReachedMax: response.next == null,
        ),
      );
    } catch (e) {
      if (state.pokemons.isNotEmpty) {
        emit(state.copyWith(errorMessage: e.toString()));
      } else {
        emit(
          state.copyWith(
            status: PokemonListStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } finally {
      _isFetching = false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    state.scrollController.dispose();
    return super.close();
  }
}
