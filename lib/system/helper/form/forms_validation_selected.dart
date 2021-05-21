import '../../resource/validation_messages.dart';

class FormsValidationSelected {
  
  List<_FieldsValidationsSingleCheck> _fieldsValidationSingleCheck = [];

  List<_FieldsValidationsMultiCheck> _fieldsValidationMultiCheck = [];

  List<_FieldsValidationsRadio> _fieldsValidationRadio = [];

  Map<String, String> _formErrors = {};

  String _languageValidation = ValidationMessage.validationMessageId;
  
  set setLanguageValidation(String language) {
    if(ValidationMessage.validationMessages.containsKey(language)) {
      _languageValidation = language;
    }
  }
  
  /// Parameters
  /// * name ex : required
  /// * text : The {field} is required
  ///
  /// Example :
  /// ```dart
  /// valid.setErrorMessage("gt", "The {field} must greater than {param}.");
  /// ```
  void setErrorMessage(String name, String text)
  {
    _formErrors[name] = text;
  }

  dynamic _getList(String? name) {
    
    var single = _fieldsValidationSingleCheck.where((element) => element.name == name);
    var radio = _fieldsValidationRadio.where((element) => element.name == name);
    var multi = _fieldsValidationMultiCheck.where((element) => element.name == name);

    if(single.length > 0) return single.first;
    else if(radio.length > 0) return radio.first;
    else if(multi.length > 0) return multi.first;
    return null;
  }

  /// Validations : required, required_if
  void setRulesSingleCheck(String name, String? validations, String label) {
    var data = new _FieldsValidationsSingleCheck();
    data.checked = false;
    data.isError = false;
    data.name = name;
    data.validations = validations;
    data.label = label;
    _fieldsValidationSingleCheck.add(data);
  }

  /// Validations : required, required_if
  void setRulesRadio(String name, String? validations, String label) {
    var data = new _FieldsValidationsRadio();
    data.value = "";
    data.isError = false;
    data.name = name;
    data.validations = validations;
    data.label = label;
    _fieldsValidationRadio.add(data);
  }

  void setRulesMultiCheck(String name, String? validations, String label, int length) {
    var data = new _FieldsValidationsMultiCheck();
    Map<int, bool> checked = {};
    for(int i = 0; i < length; i++) {
      checked[i] = false;
    }
    data.checked = checked;
    data.isError = false;
    data.name = name;
    data.validations = validations;
    data.label = label;
    _fieldsValidationMultiCheck.add(data);
  }

  String _errorMessage(String name, String? label, String validation, {String? param}) {
    var showError = _formErrors.containsKey(validation) ? _formErrors[validation] : ValidationMessage.validationMessages[_languageValidation]![validation];
    return param != null ? _updateMessageError(showError!, label!, kategori: 1, param: param) : _updateMessageError(showError!, label ?? name);
  }

  void updateValueSingleCheck(String name, bool? value) {
    _fieldsValidationSingleCheck.forEach((element) {
      if(element.name == name) {
        element.checked = value;
      }
    });
  }
  void updateValueRadio(String name, String value) {
    _fieldsValidationRadio.forEach((element) {
      if(element.name == name) {
        element.value = value;
      }
    });
  }

  void updateValueMultiCheck(String name, int index, bool value) {
    _fieldsValidationMultiCheck.forEach((element) {
      if(element.name == name) {
        element.checked[index] = value;
      }
    });
  }

  String? getError(String name) {
    if(_fieldsValidationMultiCheck.where((element) => element.name == name).length > 0) return _getErrorMultiCheck(name);
    else if(_fieldsValidationRadio.where((element) => element.name == name).length > 0) return _getErrorRadio(name);
    return _getErrorSingleCheck(name);
  }

  String? _getErrorSingleCheck(String name) {
    var checkbox = _fieldsValidationSingleCheck.where((element) => element.name == name);
    if(
        checkbox.length > 0 && checkbox.first.validations != null
      ) {
      var data = checkbox.first;
      String? errorMessage;
      var explode = data.validations!.split("|");
      explode.forEach((validation) {
        var valid = validation.split(":");
        if(valid[0] == 'required' && !data.checked!) {
          errorMessage = _errorMessage(name, data.label, "required");
          return;
        }
        else if(valid[0] == 'required_if' && valid.length > 1 && !data.checked! && _isRequiredIfCheck(valid[1])!) {
          errorMessage = _errorMessage(name, data.label, "required_if");
          return;
        }
      });
      return errorMessage;
    }
    return null;
  }

  String? _getErrorRadio(String name) {
    var radio = _fieldsValidationRadio.where((element) => element.name == name);
    if(
        radio.length > 0 && radio.first.validations != null
      ) {
      var data = radio.first;
      String? errorMessage;
      var explode = data.validations!.split("|");
      explode.forEach((validation) {
        var valid = validation.split(":");
        if(valid[0] == 'required' && (data.value == "" || data.value == null)) {
          errorMessage = _errorMessage(name, data.label, "required");
          return;
        }
        else if(valid[0] == 'required_if' && valid.length > 1 && (data.value == "" || data.value == null) && _isRequiredIfCheck(valid[1])!) {
          errorMessage = _errorMessage(name, data.label, "required_if");
          return;
        }
      });
      return errorMessage;
    }
    return null;
  }

  String? _getErrorMultiCheck(String name) {
    var data = _fieldsValidationMultiCheck.where((element) => element.name == name).first;
    if(data.validations != null) {
      
      bool isChecked = false;
      int countChecked = 0;

      data.checked.forEach((key, value) {
        if(value) {
          isChecked = true;
          countChecked += 1;
        }
      });

      String? errorMessage;
      var explode = data.validations!.split("|");
      explode.forEach((validation) {
        var valid = validation.split(":");
        if(valid[0] == 'required' && !isChecked) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "required");
          return;
        }
        else if(valid[0] == 'required_if' && valid.length > 1 && !isChecked && _isRequiredIfCheck(valid[1])!) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "required_if");
          return;
        }
        else if(valid[0] == 'equal_checked' && valid.length > 1 && countChecked != int.parse(valid[1])) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "equal_checked");
          return;
        }
        else if(valid[0] == 'gt_checked' && valid.length > 1 && int.parse(valid[1]) < countChecked) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "gt_checked");
          return;
        }
        else if(valid[0] == 'lt_checked' && valid.length > 1 && countChecked > int.parse(valid[1])) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "lt_checked");
          return;
        }
        else if(valid[0] == 'gte_checked' && valid.length > 1 && int.parse(valid[1]) <= countChecked) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "gte_checked");
          return;
        }
        else if(valid[0] == 'lte_checked' && valid.length > 1 && countChecked >= int.parse(valid[1])) {
          errorMessage = _errorMessage(name, data.label ?? data.name, "lte_checked");
          return;
        }
      });
      return errorMessage;
    }
    return null;
  }

  /// return true jika input tidak kosong atau tercentang
  bool? _isRequiredIfCheck(String name) {
    var single = _fieldsValidationSingleCheck.where((element) => element.name == name);
    var radio = _fieldsValidationRadio.where((element) => element.name == name);
    var multi = _fieldsValidationMultiCheck.where((element) => element.name == name);
    if(single.length > 0) return single.first.checked;
    else if(radio.length > 0) return radio.first.value != "" || radio.first.value!.isNotEmpty;
    else if(multi.length > 0) {
      bool isFind = false;
      multi.first.checked.forEach((key, value) {
        if(value) isFind = true;
      });
      return isFind;
    }
    return false;
  }

  /// * kategori 0 : untuk parameter panjang
  /// * kategori 1 : untuk parameter field (Contoh "same")
  String _updateMessageError(String error, String label, {String? param, int? kategori, String? name})
  {
    var replace = error.replaceAll(new RegExp(r'{field}'), label);
    if(param != null)
    {
      if(kategori == 0)
      {
        replace = replace.replaceAll(new RegExp(r'{param}'), param);
      }
      else if(kategori == 1)
      {
        
        replace = replace.replaceAll(new RegExp(r'{param}'), _getList(name).label);
      }
    }
    return replace;
  }
}

class _FieldsValidationsSingleCheck {
  String? name;
  String? validations;
  String? label;
  bool? checked;
  bool? isError;
}

class _FieldsValidationsRadio {
  String? name;
  String? validations;
  String? label;
  String? value;
  bool? isError;
}

class _FieldsValidationsMultiCheck {
  String? name;
  String? validations;
  String? label;
  late Map<int, bool> checked;
  bool? isError;
}