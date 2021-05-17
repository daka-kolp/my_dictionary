import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Environment {
  dev,
  prod,
}

class GlobalConfig {
  final Environment environment;
  final String mainImagePath;
  final int fetchStep = 20;

  GlobalConfig({
    required this.environment,
    required this.mainImagePath,
  });
}
