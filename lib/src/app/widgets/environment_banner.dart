import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/global_config.dart';

class EnvironmentBanner extends StatelessWidget {
  final Environment environment;
  final Widget child;

  EnvironmentBanner({required this.child})
      : environment = GetIt.I<GlobalConfig>().environment;

  _BannerProps get _bannerProps {
    switch (environment) {
      case Environment.dev:
        return _BannerProps ('DEV', Colors.green);
      default:
        return _BannerProps ('UNKNOWN', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (environment == Environment.prod) {
      return child;
    }

    return Banner(
      message: _bannerProps.info,
      color: _bannerProps.color,
      textDirection: TextDirection.ltr,
      layoutDirection: TextDirection.ltr,
      location: BannerLocation.topStart,
      child: child,
    );
  }
}

class _BannerProps {
  final String info;
  final Color color;

  _BannerProps(this.info, this.color);
}
