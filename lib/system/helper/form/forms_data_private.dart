import 'package:flutter/material.dart';
import 'forms_checkboxs_error.dart';
import 'forms_selected_radio.dart';

class FormsDataPrivate {
  
  Map<String, TextEditingController> inputController = {};

  Map<String, bool> isCheckboxRequired = {};

  Map<String, String> getSelectedDropdown = {};

  Map<String, bool> isRadioRequired = {};

  Map<String, FormsCheckboxsError> checkboxsError = {};

  Map<String, FormsSelectedRadio> getCheckedRadio = {};

  Map<String, List<bool>> getCheckboxs = {};

  Map<String, bool> getErrorRadio = {};

  Map<String, bool> getErrorCheckbox = {};

  Map<String, bool> getErrorDropdown = {};

  Map<String, dynamic> getValue = {};

  Map<String, bool> formEnabled = {};

  bool validate;

}