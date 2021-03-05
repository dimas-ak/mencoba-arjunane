import 'package:flutter/material.dart';
import 'helper/components/components_alerts_notifier.dart';

class ArjunaneModel extends ChangeNotifier {

  AlertsDialogStatus _alertsDialogStatus = AlertsDialogStatus.progress;
  String _alertsDialogMessage;

  AlertsDialogStatus get getAlertsDialogNotifierStatus => _alertsDialogStatus;
  String get getAlertsDialogNotifierMessage => _alertsDialogMessage;

  set changeStatusAlertDialogNotifier(AlertsDialogStatus status) {
    _alertsDialogStatus = status;
    notifyListeners();
  }

  set changeMessageAlertDialogNotifier(String message) {
    _alertsDialogMessage = message;
    notifyListeners();
  }
}