import 'package:flutter/material.dart';

class MyDictionaryTheme {
  late final MaterialColor _materialColor;
  late final MaterialAccentColor _accentColor;
  late final ThemeData _themeData;

  ThemeData get theme => _themeData;

  MyDictionaryTheme.dev() {
    _materialColor = _createMaterialColor(Color(0xff00848C));
    _accentColor = _createMaterialAccentColor(Color(0xfff05945));
    _themeData = _getTheme(_materialColor, _accentColor);
  }

  MyDictionaryTheme.prod() {
    _materialColor = _createMaterialColor(Color(0xff03256c));
    _accentColor = _createMaterialAccentColor(Color(0xffe5d549));
    _themeData = _getTheme(_materialColor, _accentColor);
  }

  static ThemeData _getTheme(
    MaterialColor materialColor,
    MaterialAccentColor accentColor,
  ) {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: materialColor,
        primaryColorDark: materialColor.shade700,
        accentColor: accentColor,
        cardColor: Color(0xffffffff),
        backgroundColor: Color(0xffffffff),
        errorColor: Colors.red.shade700,
        brightness: Brightness.light,
      ),
    ).copyWith(
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: accentColor.shade100,
          onPrimary: Colors.black,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = [.05];
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    final swatches = _generateSwatches(color, strengths);
    return MaterialColor(color.value, swatches);
  }

  MaterialAccentColor _createMaterialAccentColor(Color color) {
    List<double> strengths = [];
    for (int i = 0; i < 4; i++) {
      final last = strengths.lastWhere((_) => true, orElse: () => 0.1);
      strengths.add(last + i * 0.1);
    }
    Map<int, Color> swatches = _generateSwatches(color, strengths);
    return MaterialAccentColor(color.value, swatches);
  }

  Map<int, Color> _generateSwatches(Color color, List<double> strengths) {
    Map<int, Color> swatches = {};
    final int r = color.red, g = color.green, b = color.blue;
    strengths.forEach((strength) {
      final ds = 0.5 - strength;
      swatches[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return swatches;
  }
}
