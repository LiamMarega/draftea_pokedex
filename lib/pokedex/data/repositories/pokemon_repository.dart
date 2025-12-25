import 'package:dio/dio.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_list_response.dart';
import 'package:draftea_pokedex/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPokemonRepository)
class PokemonRepository implements IPokemonRepository {
  PokemonRepository(this._dio);

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
}
