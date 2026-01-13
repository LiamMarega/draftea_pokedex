import 'package:draftea_pokedex/pokedex/data/models/pokemon_detail.dart';
import 'package:draftea_pokedex/pokedex/data/models/pokemon_stat.dart';
import 'package:draftea_pokedex/pokedex/domain/entities/entities.dart';

/// Mapper to convert between data models and domain entities.
/// This keeps the data layer concerns separated from the domain.
abstract class PokemonMapper {
  /// Convert a [PokemonDetail] data model to a [Pokemon] domain entity.
  static Pokemon toEntity(PokemonDetail model) {
    return Pokemon(
      id: model.id,
      name: model.name,
      types: _mapTypes(model),
      stats: _mapStats(model),
      sprites: _mapSprites(model),
      height: model.height,
      weight: model.weight,
      abilities: _mapAbilities(model),
      baseExperience: model.baseExperience,
    );
  }

  /// Convert a list of [PokemonDetail] to a list of [Pokemon] entities.
  static List<Pokemon> toEntityList(List<PokemonDetail> models) {
    return models.map(toEntity).toList();
  }

  static List<PokemonType> _mapTypes(PokemonDetail model) {
    if (model.types.isEmpty) {
      return [PokemonType.unknown];
    }
    return model.types.map((t) => PokemonType.fromString(t.type.name)).toList();
  }

  static PokemonStats _mapStats(PokemonDetail model) {
    int getStat(String name) {
      final stat = model.stats.firstWhere(
        (s) => s.stat?.name == name,
        orElse: () => const PokemonStat(baseStat: 0, effort: 0, stat: null),
      );
      return stat.baseStat ?? 0;
    }

    // Try catch block removed as checking is safer now
    return PokemonStats(
      hp: getStat('hp'),
      attack: getStat('attack'),
      defense: getStat('defense'),
      specialAttack: getStat('special-attack'),
      specialDefense: getStat('special-defense'),
      speed: getStat('speed'),
    );
  }

  static PokemonSprites _mapSprites(PokemonDetail model) {
    return PokemonSprites(
      frontDefault: model.sprites.frontDefault,
      // Back default and shiny are not in the current models
      backDefault: null,
      frontShiny: null,
      backShiny: null,
      officialArtwork: model.sprites.other?.officialArtwork?.frontDefault,
      // DreamWorld is not in current models
      dreamWorld: null,
    );
  }

  static List<PokemonAbilityInfo> _mapAbilities(PokemonDetail model) {
    return model.abilities
        .map(
          (a) => PokemonAbilityInfo(
            name: a.ability.name,
            isHidden: a.isHidden,
            slot: a.slot,
          ),
        )
        .toList();
  }
}
