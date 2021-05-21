//import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../resource/validation_messages.dart';

class Validation
{

  Map<String?, String?>_fields = {};

  List<_FieldsValidations> _fieldsValidation = [];

  Map<String, String> _formErrors = {};

  String _languageValidation = ValidationMessage.validationMessageId;

  set setLanguageValidation(String language) {
    if(ValidationMessage.validationMessages.containsKey(language)) {
      _languageValidation = language;
    }
  }

  // Map<String,bool Function(String a)> methods = new Map<String,bool Function(String a)>();

  // bool isEnabled;

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
  /// Parameters :
  /// * value : is from Validator or OnInput, etc
  /// * validations : "required|max_length:50" 
  /// 
  /// Optionals :
  /// * name : "email" or "username", etc
  /// * label : "E-Mail" or "Your Username", etc
  /// 
  /// Example :
  /// ```dart
  /// valid.setRules(value, "E-Mail", "required|max_length:50", name : "email");
  /// ```
  String? setRules(String? value, String label, String validations, {String? name})
  {
    var validation = validations.split('|');

    var list = _fieldsValidation.indexWhere((e) => e.name == name);
    
    if(list == -1 || (list != -1 && _fieldsValidation[list].validations == null))
    {
      var data          = new _FieldsValidations();
      data.name          = name;
      data.validations  = value;
      data.label        = label;
      _fieldsValidation.add(data);
    }
    
    for(var e in validation)
    {
      if(e == "nullable")
      {
        if(_isErrorRequired(value)) return null;
        else continue;
      }

      var isParam = e.split(':');
      var param = isParam.length > 1 ? isParam[1] : null;
      
      _fields[name] = value;

      var isError = _isError(value, isParam[0], label, param);
      if(isError != null) return isError;
    }
    return null;
  }

  // TextEditingController setController(String name)
  // {    
  //   final TextEditingController controller = new TextEditingController();
  //   var data  = new _FieldsValidations();
  //   data.name        = name;
  //   data.controller = controller;

  //   _fieldsValidation.add(data);
  //   return controller;
  // }
  // TextEditingController getController(String name)
  // {
  //   int index = _fieldsValidation.indexWhere((e) => e.name == name);
  //   if(index != -1)
  //   {
  //     return _fieldsValidation[index].controller;
  //   }
  //   return null;
  // }

  ///The getText() method is used to get a value from the input
  String? getText(String? name)
  {
    return _fields[name];
  }

  /// The all() method is to get all values from the inputs
  /// 
  /// only:
  ///- Get current values with returns only the specified name pairs from the given array.
  /// 
  /// except:
  ///- Get current values with returns except the specified name pairs from the given array.
  Map<String?, String?> all({List<String>? only, List<String>? except})
  {
    Map<String?, String?> newFields = new Map<String?, String?>();
    if(only != null && only.length > 0)
    {
      only.forEach((e) {
        if(_fields.containsKey(e)) newFields[e] = _fields[e];
      });
      return newFields;
    }
    else if(except != null && except.length > 0)
    {
      _fields.forEach((name, value) {
        if(!except.contains(name)) newFields[name] = _fields[name];
      });
      return newFields;
    }
    return _fields;
  }
  
  String? _isError(String? value, String validation, String label, String? param)
  {
    var showError = _formErrors.containsKey(validation) ? _formErrors[validation] : ValidationMessage.validationMessages[_languageValidation]![validation];
    switch(validation)
    {
      case "required":
        if(_isErrorRequired(value))return _updateMessageError(showError!, label);
      break;
      case "name":
        if(_isErrorName(value!)) return _updateMessageError(showError!, label);
      break;
      case "same":
        if(_isErrorSame(value, param)) return _updateMessageError(showError!, label, kategori: 1, param: param);
      break;
      case "email":
        if(_isErrorEmail(value!)) return _updateMessageError(showError!, label);
      break;
      case "numeric":
        if(_isErrorNumeric(value!)) return _updateMessageError(showError!, label);
      break;
      case "alpha":
        if(_isErrorAlpha(value!)) return _updateMessageError(showError!, label);
      break;
      case "integer":
        if(_isErrorInteger(value!)) return _updateMessageError(showError!, label);
      break;
      case "boolean":
        if(_isErrorBoolean(value)) return _updateMessageError(showError!, label);
      break;
      case "in":
        if(_isErrorInArray(value, param!)) return _updateMessageError(showError!, label);
      break;
      case "not_in":
        if(_isErrorNotInArray(value, param!)) return _updateMessageError(showError!, label);
      break;
      case "max_length":
        if(_isErrorMaxLength(value!, int.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "min_length":
        if(_isErrorMinLength(value!, int.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "max":
        if(_isErrorMax(value!, double.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "min":
        if(_isErrorMin(value!, double.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "gt":
        if(_isErrorGt(value!, double.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "lt":
        if(_isErrorLt(value!, double.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "gte":
        if(_isErrorGte(value!, double.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "lte":
        if(_isErrorLte(value!, double.parse(param!))) return _updateMessageError(showError!, label, kategori: 0, param: param);
      break;
      case "starts_with":
        if(_isErrorStartsWith(value, param!)) return _updateMessageError(showError!, label);
      break;
      case "ends_with":
        if(_isErrorEndsWith(value, param!)) return _updateMessageError(showError!, label);
      break;
      case "different":
        if(_isErrorDifferent(value, param)) return _updateMessageError(showError!, label);
      break;
      case "alpha_dash":
        if(_isErrorAlphaDash(value!)) return _updateMessageError(showError!, label);
      break;
      case "alpha_numeric":
        if(_isErrorAlphaNumeric(value!)) return _updateMessageError(showError!, label);
      break;
      case "alpha_numeric_dash":
        if(_isErrorAlphaNumericDash(value!)) return _updateMessageError(showError!, label);
      break;
      case "required_if":
        if(_isErrorRequiredIf(value, param)) return _updateMessageError(showError!, label);
      break;
      case "url":
        if(_isErrorUrl(value!)) return _updateMessageError(showError!, label);
      break;
      case "json":
        if(_isErrorJson(value!)) return _updateMessageError(showError!, label);
      break;
      case "ip":
        if(_isErrorIP(value!)) return _updateMessageError(showError!, label);
      break;
      case "ipv4":
        if(_isErrorIPv4(value!)) return _updateMessageError(showError!, label);
      break;
      case "ipv6":
        if(_isErrorIPv6(value!)) return _updateMessageError(showError!, label);
      break;
      case "regex":
        if(_isErrorRegex(value!, param!)) return _updateMessageError(showError!, label);
      break;
      case "not_regex":
        if(_isErrorNotRegex(value!, param!)) return _updateMessageError(showError!, label);
      break;
    }
    return null;
  }
  
  bool _isErrorRequired(String? value) => value == null || value.isEmpty;
  
  bool _isErrorEmail(String value) => !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value);

  bool _isErrorAlpha(String value) => !RegExp(r'^[A-Za-z]+$').hasMatch(value);

  bool _isErrorInteger(String value) => !RegExp(r'^[-+]?[1-9]\d*$').hasMatch(value);

  bool _isErrorBoolean(String? value) => value == "true" || value == 'false';

  bool _isErrorInArray(String? value, String param) {
    var split = param.split(",");
    var find = true;
    split.forEach((element) {
      if(element == value) find = false;
    });
    return find;
  }

  bool _isErrorNotInArray(String? value, String param) {
    var split = param.split(",");
    var find  = false;
    split.forEach((element) {
      if(element == value) find = true;
    });
    return find;
  }

  bool _isErrorRegex(String value, String param) => !RegExp(r'' + param).hasMatch(value);

  bool _isErrorNotRegex(String value, String param) => RegExp(r'' + param).hasMatch(value);

  bool _isErrorStartsWith(String? value, String param) {
    var params = param.split(",");
    var isFind = true;
    params.forEach((element) {
      if(!RegExp(r'^' + param).hasMatch(value!)) isFind = false;
    });
    return isFind;
  }

  bool _isErrorEndsWith(String? value, String param) {
    var params = param.split(",");
    var isFind = true;
    params.forEach((element) {
      if(RegExp(r'.*' + element + r'$').hasMatch(value!)) isFind = false;
    });
    return isFind;
  }

  bool _isErrorDifferent(String? value, String? field) => value == getText(field);

  bool _isErrorAlphaDash(String value) => !RegExp(r'^[a-zA-Z-_]+$').hasMatch(value);
  
  bool _isErrorAlphaNumeric(String value) => !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);

  bool _isErrorAlphaNumericDash(String value) => !RegExp(r'^[a-zA-Z0-9-_]+$').hasMatch(value);

  bool _isErrorRequiredIf(String? value, String? field) => 
    (getText(field) != "" || getText(field) != null)
    && value == null || value!.isEmpty;
  
  bool _isErrorSame(String? value, String? field) =>  value != getText(field);
  
  bool _isErrorName(String value) =>  new RegExp(r"^[a-zA-Z ,.']*$").allMatches(value).isEmpty;
  
  bool _isErrorNumeric(String value) => new RegExp(r"^[0-9]*$").allMatches(value).isEmpty;
  
  bool _isErrorIP(String value) => InternetAddress.tryParse(value)!.type == InternetAddressType.any;
  
  bool _isErrorIPv4(String value) => InternetAddress.tryParse(value)!.type == InternetAddressType.IPv4;
  
  bool _isErrorIPv6(String value) => InternetAddress.tryParse(value)!.type == InternetAddressType.IPv6;
  
  bool _isErrorMaxLength(String value, int param) => value.length > param;
  
  bool _isErrorMinLength(String value, int param) => value.length < param;
  
  bool _isErrorMax(String value, double param)
  { 
    try { return double.parse(value) > param; }
    catch(e) { return value.length > param; }
  }
  bool _isErrorGt(String value, double param)
  { 
    try { return double.parse(value) > param; }
    catch(e) { return false; }
  }
  bool _isErrorLt(String value, double param)
  { 
    try { return double.parse(value) < param; }
    catch(e) { return false; }
  }
  bool _isErrorGte(String value, double param)
  { 
    try { return double.parse(value) >= param; }
    catch(e) { return false; }
  }
  bool _isErrorLte(String value, double param)
  { 
    try { return double.parse(value) <= param; }
    catch(e) { return false; }
  }

  bool _isErrorUrl(String value) => Uri.parse(value).isAbsolute;

  bool _isErrorJson(String value)
  { 
    var decodeSucceeded = true;
    try {
      json.decode(value) as Map<String, dynamic>?;
      decodeSucceeded = false;
    } on FormatException {}
    return decodeSucceeded;
  }

  bool _isErrorMin(String value, double param)
  { 
    try { return double.parse(value) < param; }
    catch(e) { return value.length < param; }
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
        var list = _fieldsValidation.indexWhere((e) => e.name == name);
        
        replace = replace.replaceAll(new RegExp(r'{param}'), _fieldsValidation[list].label);
      }
    }
    return replace;
  }

}

class _FieldsValidations
{
  String? name;
  String? validations;
  late String label;
  TextEditingController? controller;
  TextField? textField;
  TextFormField? textFormField;
}