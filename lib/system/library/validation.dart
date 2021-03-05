//import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Validation
{
  final Map<String, String> formErrorsDefault = 
  {
    "ip" :                 "{field} tidak valid.",
    "gt" :                 "{field} harus lebih besar dari {param}.", //Greater Than
    "lt" :                 "{field} harus lebih kecil dari {param}.", //Lower Than
    "gte" :                "{field} harus lebih besar dari sama dengan {param}.", //Greater Than or Equal
    "lte" :                "{field} harus lebih kecil dari sama dengan {param}.", //Lower Than or Equal
    "max" :                "Maksimal Angka dari {field} ialah {param}.",
    "min" :                "Minimal Angka dari {field} ialah {param}.",
    "url" :                "{field} tidak valid.",
    "ipv4" :               "{field} tidak valid.",
    "ipv6" :               "{field} tidak valid.",
    "json" :               "{field} tidak valid.",
    "name" :               "{field} tidak valid.",
    "same" :               "{field} tidak sama dengan {param}.",
    "email" :              "{field} tidak valid.",
    "regex" :              "{field} tidak valid.",
    "alpha" :              "{field} hanya boleh diisi dengan Alphabet.",
    "integer" :            "{field} tidak valid.",
    "numeric" :            "{field} tidak valid.",
    "boolean" :            "{field} tidak valid.",
    "required" :           "{field} harap diisi.",
    "in_array" :           "{field} tidak valid.",
    "ends_with" :          "{field} harus diakhiri dengan {param}.",
    "different" :          "{field} tidak boleh sama dengan {param}.",
    "not_regex" :          "{field} tidak valid.",
    "max_length" :         "Maksimal Karakter untuk {field} ialah {param}.",
    "min_length" :         "Minimal Karakter untuk {field} ialah {param}.",
    "alpha_dash" :         "{field} hanya boleh diisi dengan Alphabet dan Garis.",
    "starts_with" :        "{field} harus diawali dengan {param}.",
    "required_if" :        "{field} harus diisi.",
    "not_in_array" :       "{field} tidak valid.",
    "alpha_numeric" :      "{field} hanya boleh diisi dengan Alphabet dan Angka.",
    "alpha_numeric_dash" : "{field} hanya boleh diisi dengan Alphabet, Angka dan Garis.",
  };

  Map<int, Map<String, String>> fields = new Map<int, Map<String, String>>();

  List<_FieldsValidations> fieldsValidation = [];

  Map<String, String> formErrors = new Map<String, String>();

  Map<String,bool Function(String a)> methods = new Map<String,bool Function(String a)>();

  bool isEnabled;

  void setErrorMessage(String name, String text)
  {
    
  }
  /// Parameters :
  /// * value : is from Validator or OnInput, etc
  /// * validations : "required|max_length:50" 
  /// 
  /// Optionals :
  /// * key : "email" or "username", etc
  /// * label : "E-Mail" or "Your Username", etc
  /// 
  /// Example :
  /// ```dart
  /// valid.setRules(value, "required|max_length:50", { key : "email", label: "E-Mail"});
  /// ```
  String setRules(String value, String label, String validations, {String key, int indexForm = 0})
  {
    var validation = validations.split('|');

    var list = fieldsValidation.indexWhere((e) => e.key == key);
    
    if(list == -1 || (list != -1 && fieldsValidation[list].validations == null))
    {
      var data          = new _FieldsValidations();
      data.key          = key;
      data.validations  = value;
      data.label        = label;
      fieldsValidation.add(data);
    }
    
    Map<String, String> _fieldError = {};
    for(var e in validation)
    {
      if(e == "nullable")
      {
        if(_isErrorRequired(value)) return null;
        else continue;
      }

      var isParam = e.split(':');
      var param = isParam.length > 1 ? isParam[1] : null;
      
      _fieldError[key] = value;
      fields[indexForm] = _fieldError;

      var isError = _isError(value, isParam[0], label, param, indexForm: indexForm);
      if(isError != null) return isError;
    }
    return null;
  }

  // TextEditingController setController(String key)
  // {    
  //   final TextEditingController controller = new TextEditingController();
  //   var data  = new _FieldsValidations();
  //   data.key        = key;
  //   data.controller = controller;

  //   fieldsValidation.add(data);
  //   return controller;
  // }
  // TextEditingController getController(String key)
  // {
  //   int index = fieldsValidation.indexWhere((e) => e.key == key);
  //   if(index != -1)
  //   {
  //     return fieldsValidation[index].controller;
  //   }
  //   return null;
  // }

  String getText(String key, {int indexForm = 0})
  {
    return fields[indexForm][key];
  }

  Map<String, String> all({List<String> only, List<String> except, int indexForm = 0})
  {
    Map<String, String> newFields = new Map<String, String>();
    if(only != null && only.length > 0)
    {
      only.forEach((e) {
        if(fields[indexForm].containsKey(e)) newFields[e] = fields[indexForm][e];
      });
      return newFields;
    }
    else if(only != null && except.length > 0)
    {
      except.forEach((e) {
        if(fields[indexForm].containsKey(e)) newFields[e] = fields[indexForm][e];
      });
      return newFields;
    }
    return fields[indexForm];
  }
  
  String _isError(String value, String validation, String label, String param, {int indexForm = 0})
  {
    var showError = formErrors.containsKey(validation) ? formErrors[validation] : formErrorsDefault[validation];
    switch(validation)
    {
      case "required":
        if(_isErrorRequired(value))return _updateMessageError(showError, label);
      break;
      case "name":
        if(_isErrorName(value)) return _updateMessageError(showError, label);
      break;
      case "same":
        if(_isErrorSame(value, param, indexForm)) return _updateMessageError(showError, label, kategori: 1, param: param);
      break;
      case "email":
        if(_isErrorEmail(value)) return _updateMessageError(showError, label);
      break;
      case "numeric":
        if(_isErrorNumeric(value)) return _updateMessageError(showError, label);
      break;
      case "max_length":
        if(_isErrorMaxLength(value, int.parse(param))) return _updateMessageError(showError, label, kategori: 0, param: param);
      break;
      case "min_length":
        if(_isErrorMinLength(value, int.parse(param))) return _updateMessageError(showError, label, kategori: 0, param: param);
      break;
      case "max":
        if(_isErrorMax(value, double.parse(param))) return _updateMessageError(showError, label, kategori: 0, param: param);
      break;
      case "min":
        if(_isErrorMin(value, double.parse(param))) return _updateMessageError(showError, label, kategori: 0, param: param);
      break;
      case "ip":
        if(_isErrorIP(value)) return _updateMessageError(showError, label);
      break;
      case "ipv4":
        if(_isErrorIPv4(value)) return _updateMessageError(showError, label);
      break;
      case "ipv6":
        if(_isErrorIPv6(value)) return _updateMessageError(showError, label);
      break;
    }
    return null;
  }
  
  bool _isErrorRequired(String value)
  {
    return value == null || value.isEmpty;
  }
  bool _isErrorEmail(String value)
  {
    return !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value);
  }
  bool _isErrorSame(String value, String param, int indexForm)
  {
    return value != fields[indexForm][param];
  }
  bool _isErrorName(String value)
  {
    RegExp regex = new RegExp(r"^[a-zA-Z ,.']*$");
    return regex.allMatches(value) == null;
  }
  bool _isErrorNumeric(String value)
  {
    RegExp regex = new RegExp(r"^[0-9]*$");
    return regex.allMatches(value) == null;
  }
  bool _isErrorIP(String value)
  { 
    return InternetAddress.tryParse(value).type == InternetAddressType.any;
  }
  bool _isErrorIPv4(String value)
  { 
    return InternetAddress.tryParse(value).type == InternetAddressType.IPv4;
  }
  bool _isErrorIPv6(String value)
  { 
    return InternetAddress.tryParse(value).type == InternetAddressType.IPv6;
  }
  bool _isErrorMaxLength(String value, int param)
  { 
    return value.length > param;
  }
  bool _isErrorMinLength(String value, int param)
  { 
    return value.length < param;
  }
  bool _isErrorMax(String value, double param)
  { 
    try
    {
      return double.parse(value) > param;
    }
    catch(e)
    {
      return value.length > param;
    }
  }
  bool _isErrorMin(String value, double param)
  { 
    try
    {
      return double.parse(value) < param;
    }
    catch(e)
    {
      return value.length < param;
    }
  }

  /// * kategori 0 : untuk parameter panjang
  /// * kategori 1 : untuk parameter field (Contoh "same")
  String _updateMessageError(String error, String label, {String param, int kategori, String key})
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
        var list = fieldsValidation.indexWhere((e) => e.key == key);
        
        replace = replace.replaceAll(new RegExp(r'{param}'), fieldsValidation[list].label);
      }
    }
    return replace;
  }

}

class _FieldsValidations
{
  String key;
  String validations;
  String label;
  TextEditingController controller;
  TextField textField;
  TextFormField textFormField;
}