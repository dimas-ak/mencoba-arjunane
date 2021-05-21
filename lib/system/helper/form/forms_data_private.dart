import 'package:flutter/material.dart';
import 'forms_selected_radio.dart';

class FormsDataPrivate {
  
  Map<String, TextEditingController> inputController = {};

  Map<String, String?> getSelectedDropdown = {};

  Map<String, FormsSelectedRadio> getCheckedRadio = {};

  Map<String, List<bool?>> getCheckboxs = {};

  Map<String, bool> getErrorDropdown = {};

  Map<String, dynamic> getValue = {};

  Map<String, bool> formEnabled = {};

  bool? validate;

  Map<String, bool> isErrorForm = {};

}