import 'package:flutter/material.dart';
import '../../helper/components/components_buttons_notifier_status.dart';

class ArjunaneModelButtonsNotifier extends ChangeNotifier {

  Map<String, ButtonsNotifierStatus> _buttonsNotifier = {};

  Map<String, ButtonsNotifierStatus> get getButtonsNotifier => _buttonsNotifier;
  
  set changeButtonsNotifierStatus(Map<String, ButtonsNotifierStatus> buttonsNotifier) {
    _buttonsNotifier = buttonsNotifier;
    notifyListeners();
  }
}