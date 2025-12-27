enum PokemonType {
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  unknown,
  shadow;

  static PokemonType fromString(String type) {
    try {
      return PokemonType.values.firstWhere((e) => e.name == type);
    } catch (_) {
      return PokemonType.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case PokemonType.steel:
        return 'Acero';
      case PokemonType.water:
        return 'Agua';
      case PokemonType.bug:
        return 'Bicho';
      case PokemonType.dragon:
        return 'Dragón';
      case PokemonType.electric:
        return 'Eléctrico';
      case PokemonType.ghost:
        return 'Fantasma';
      case PokemonType.fire:
        return 'Fuego';
      case PokemonType.fairy:
        return 'Hada';
      case PokemonType.ice:
        return 'Hielo';
      case PokemonType.fighting:
        return 'Lucha';
      case PokemonType.normal:
        return 'Normal';
      case PokemonType.grass:
        return 'Planta';
      case PokemonType.psychic:
        return 'Psíquico';
      case PokemonType.rock:
        return 'Roca';
      case PokemonType.dark:
        return 'Siniestro';
      case PokemonType.ground:
        return 'Tierra';
      case PokemonType.poison:
        return 'Veneno';
      case PokemonType.flying:
        return 'Volador';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }
}
