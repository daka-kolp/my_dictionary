import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Environment {
  dev,
  prod,
}

class GlobalConfig {
  final Environment environment;
  final ThemeData theme;

  GlobalConfig({
    @required this.environment,
    @required this.theme,
  })  : assert(environment != null),
        assert(theme != null);
}
