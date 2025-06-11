import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:path_provider/path_provider.dart";

import "src/app.dart";
import "src/configs/injector/injector_conf.dart";
import "src/core/utils/observer.dart";

//Test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Hive.initFlutter(),
    getTemporaryDirectory().then((path) async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(path.path),
      );
    }),
  ]);

  configureDepedencies();

  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}
