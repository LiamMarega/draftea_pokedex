import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';
import 'package:draftea_pokedex/pokedex/domain/usecases/usecases.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'pokedex_cubit.freezed.dart';
part 'pokedex_state.dart';

@injectable
class PokedexCubit extends Cubit<PokedexState> {
  // Inject UseCase instead of Repository directly
  PokedexCubit(this._getPokemonListUseCase)
    : super(
        PokedexState(
          scrollController: ScrollController(),
        ),
      ) {
    _initScrollListener();
    _initConnectivityListener();
  }

  final GetPokemonListUseCase _getPokemonListUseCase;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // The repository handles the batch fetching now, so we just care about pagination
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
      // Calculate expected count for skeleton display logic (optional UI enhancement)
      final newExpectedCount = state.expectedCount + _pageSize;
      emit(state.copyWith(expectedCount: newExpectedCount));

      // Use the UseCase to get the list of Pokemon entities
      final result = await _getPokemonListUseCase(
        PaginationParams(
          offset: state.currentOffset,
          limit: _pageSize,
        ),
      );

      emit(
        state.copyWith(
          status: PokemonListStatus.success,
          pokemons: [...state.pokemons, ...result.pokemons],
          currentOffset: state.currentOffset + _pageSize,
          hasReachedMax: !result.hasMore,
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
