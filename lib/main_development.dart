import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
