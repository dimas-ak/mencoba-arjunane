import 'package:flutter/material.dart';
import '../helper/flat_colors.dart';

final Map<String, ThemeData> themeCustom = {
  "light" : ThemeData(
    brightness: Brightness.light,
    accentColor: Colors.white
  ),
  "dark" : ThemeData(
    brightness: Brightness.dark,
    accentColor: FlatColors.googleBlack,
    primaryColor: FlatColors.germanBlack
  )
};