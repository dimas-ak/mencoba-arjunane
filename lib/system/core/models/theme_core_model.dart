import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme_core_property.dart';
import '../../resource/theme_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCoreModel extends ChangeNotifier {

  ThemeData? _themeData;

  ThemeData? get themeData => _themeData;

  ThemeCoreModel() {
    SharedPreferences.getInstance().then((value) {
      _themeData = themeCustom[!value.containsKey(ThemeCoreProperty.themeKey) ? ThemeCoreProperty.defaultThemeName : value.getString(ThemeCoreProperty.themeKey)!];
      notifyListeners();
    });
  }

  void changeTheme(String name) async {
    final shared = await SharedPreferences.getInstance();
    if(themeCustom.containsKey(name) || (shared.getString(ThemeCoreProperty.themeKey) != name && themeCustom.containsKey(name))) {
      shared.setString(ThemeCoreProperty.themeKey, name);
      ThemeCoreProperty.themeChoosenName = name;
      _themeData = themeCustom[name];
      notifyListeners();
    }
  }
}