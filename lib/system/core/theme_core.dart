import 'package:flutter/material.dart';
import 'models/theme_core_model.dart';
import 'theme_core_property.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resource/theme_custom.dart';

class ThemeCore {

  static changeTheme(String name, BuildContext context) => Provider.of<ThemeCoreModel>(context, listen: false).changeTheme(name);

  static Future<String?> get themeChoosenName async {
    final shared = await SharedPreferences.getInstance();
    return shared.containsKey(ThemeCoreProperty.themeKey) ? shared.getString(ThemeCoreProperty.themeKey) : ThemeCoreProperty.defaultThemeName;
  }

  static ThemeData? get themeData {
    return themeCustom[ThemeCoreProperty.themeChoosenName];
  }

}