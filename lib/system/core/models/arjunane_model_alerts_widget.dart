import 'package:flutter/material.dart';

class ArjunaneModelAlertsWidget extends ChangeNotifier {
  
  String _keyAlertsWidget;

  String get getKeyAlertsWidget => _keyAlertsWidget;

  set changeAlertsWidget(String key) {
    _keyAlertsWidget = key;
    notifyListeners();
  }
}