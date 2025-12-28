import 'package:dio/dio.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';
import 'package:injectable/injectable.dart';

abstract class IPokemonRemoteDataSource {
  Future<PokemonListResponse> getPokemonList({int limit = 20, int offset = 0});
  Future<PokemonDetail> getPokemon(int id);
}

@LazySingleton(as: IPokemonRemoteDataSource)
class PokemonRemoteDataSource implements IPokemonRemoteDataSource {
  PokemonRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<PokemonListResponse> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/pokemon',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );

    if (response.data == null) {
      throw Exception('No data received');
    }

    return PokemonListResponse.fromJson(response.data!);
  }

  @override
  Future<PokemonDetail> getPokemon(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/pokemon/$id');

    if (response.data == null) {
      throw Exception('No data received');
    }

    return PokemonDetail.fromJson(response.data!);
  }
}
