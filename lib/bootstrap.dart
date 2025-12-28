import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:draftea_pokedex/core/di/injection.dart';
import 'package:draftea_pokedex/hive_registrar.g.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/adapters.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapters();

  configureDependencies();

  // Add cross-flavor configuration here

  runApp(await builder());
}
