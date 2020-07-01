import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/domain/entities/global_config.dart';

void main() {
  GetIt.I.registerSingleton<GlobalConfig>(
    GlobalConfig(environment: Environment.prod),
  );

  runMyDictionaryApp();
}
