import 'package:flutter/cupertino.dart';

class ArjunaneModelForms extends ChangeNotifier {
  
  Map<String, bool> _enabledForms = {};

  Map<String, Map<String, String>> _formsDropdown = {};

  Map<String, Map<String, bool>> _formsCheckbox = {};

  Map<String, Map<String, bool>> _errorCheckbox = {};

  Map<String, Map<String, bool>> _errorRadio = {};

  Map<String, Map<String, String>> _formsDatePicker = {};

  Map<String, Map<String, String>> _formsRadio = {};

  Map<String, bool> get getEnabledForms => _enabledForms;

  Map<String, Map<String, String>> get getFormsDropdown => _formsDropdown;

  Map<String, Map<String, bool>> get getFormsCheckbox => _formsCheckbox;

  Map<String, Map<String, String>> get getFormsDatePicker => _formsDatePicker;

  Map<String, Map<String, bool>> get getErrorCheckbox => _errorCheckbox;

  Map<String, Map<String, bool>> get getErrorRadio => _errorRadio;

  Map<String, Map<String, String>> get getFormsRadio => _formsRadio;
  
  set changeEnabledForms(Map<String, bool> enabledForms) {
    _enabledForms = enabledForms;
    notifyListeners();
  }

  set changeDropdown(Map<String, Map<String, String>> formsDropdown) {
    _formsDropdown = formsDropdown;
    notifyListeners();
  }

  set changeDatePicker(Map<String, Map<String, String>> formsDatePicker) {
    _formsDatePicker = formsDatePicker;
    notifyListeners();
  }

  set changeCheckbox(Map<String, Map<String, bool>> formsCheckbox) {
    _formsCheckbox = formsCheckbox;
    notifyListeners();
  }

  set changeErrorCheckbox(Map<String, Map<String, bool>> errorCheckbox) {
    _errorCheckbox = errorCheckbox;
    notifyListeners();
  }

  set changeErrorRadio(Map<String, Map<String, bool>> errorRadio) {
    _errorRadio = errorRadio;
    notifyListeners();
  }

  set changeRadio(Map<String, Map<String, String>> formsRadio) {
    _formsRadio = formsRadio;
    notifyListeners();
  }

  set setEmpty(String mencoba) {
    notifyListeners();
  }
}