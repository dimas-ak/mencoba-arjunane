import 'package:flutter/material.dart';
import '../../../system/helper/form/forms_validation_selected.dart';
import '../../../system/helper/components/components_labeled_radio.dart';
import '../../../system/helper/form/forms_methods_private.dart';
import 'package:provider/provider.dart';
import '../../../system/core/models/arjunane_model_forms.dart';
import '../../../system/helper/form/forms_request.dart';
import '../../../system/helper/form/forms.dart';

import '../../library/validation.dart';
import '../flat_colors.dart';
import 'forms_checkbox_data.dart';
import 'forms_radio_data.dart';
import 'forms_selected_radio.dart';

class FormsWidget {

  Validation _valid = new Validation();

  final GlobalKey<FormState> _globalKey;

  final void Function(FormsRequest) _onSubmit;

  final void Function(FormsWidget)? _onInit;

  late FormsRequest _fr;

  late FormsMethodsPrivate _fmp;

  final BuildContext context;

  final bool _isFirst;

  FormsWidget? _formWidget;

  final String _keyForms;

  final FormOpenState _formOpen;

  final ArjunaneModelForms _modelForms;

  final FormsValidationSelected _validSelected;

  FormsWidget(this.context, this._globalKey, this._formOpen, this._onSubmit, this._onInit, this._isFirst, this._modelForms, this._keyForms, this._validSelected) {

    assert(this._onSubmit != null, "The method 'onSubmit' is required at FormOpen.");
    _fmp = new FormsMethodsPrivate(this, _formOpen);
    _fr = new FormsRequest(_formOpen);

    _formWidget = this;
    if(_isFirst) WidgetsBinding.instance!.addPostFrameCallback((_) {
      if(this._onInit != null) this._onInit!(this);
    });
    
  }

  Widget formInput(String label, String name, {
    String? placeholder,
    IconData? icon, 
    String? validations, 
    bool obscureText = false, 
    bool isRequired = true,
    String? optionalText,
    bool readonly = false,
    Function? onTap,
    bool isTextArea = false,
    TextInputType keyboardType = TextInputType.text, 
    void Function(String)? onChanged,
    Color colorIcon = FlatColors.v1White4,
    Widget? suffixIcon
  }) {
    if(!_formOpen.private.inputController.containsKey(name)) { 
      _formOpen.private.formEnabled[name] = true;
      setTextEditingController(name, null);
    }
    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Flexible(
        child: TextFormField(
        onTap: onTap as void Function()?,
        maxLines: isTextArea ? 8 : 1,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: getTextEditingController(name),
        readOnly: readonly,
        validator: (value) {
          _formOpen.private.getValue[name] = value;
          print("Value dari input : ${_formOpen.private.getValue}");
          return validations != null ? _valid.setRules(value, label, validations, name: name) : null;
        },
        style: TextStyle(fontSize: 16),
        enabled: _fmp.enabledForm(name),
        onChanged: onChanged,
        decoration: InputDecoration( 
          contentPadding: EdgeInsets.only(top: 0),
          labelStyle: TextStyle(
            //height: 2,
            fontSize: 18, 
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always, labelText: label,
          hintText: placeholder,
          hintStyle: TextStyle(fontSize: 16),
          suffixIcon: suffixIcon
        )
      ))
      );

  }

  Widget formInputDatePicker(String label, String name, {
      required DateTime firstDate,
      required DateTime lastDate,
      String? placeholder,
      IconData? icon, 
      String? validations, 
      bool isRequired = true,
      String? optionalText,
      String Function(DateTime)? customDateFormat,
      bool readonly = false,
      Function? onTap,
      TextInputType keyboardType = TextInputType.datetime, 
      void Function(String)? onChanged,
      Color colorIcon = FlatColors.v1White4,
      Widget? suffixIcon
    }) {
    
    if(!_formOpen.private.inputController.containsKey(name)) {
      _formOpen.private.formEnabled[name] = true;
      setTextEditingController(name, null);
    }
    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Flexible(
        child: TextFormField(
        onTap: () {
          _fmp.onTapDatePicker(name, customDateFormat);
          if(onTap != null) onTap();
        },
        keyboardType: keyboardType,
        controller: getTextEditingController(name),
        readOnly: readonly,
        validator: (value) {
          _formOpen.private.getValue[name] = value;
          return validations != null ? _valid.setRules(value, label, validations, name: name) : null;
        },
        style: TextStyle(fontSize: 16),
        enabled: _fmp.enabledForm(name),
        onChanged: onChanged,
        decoration: InputDecoration( 
          contentPadding: EdgeInsets.only(top: 0),
          labelStyle: TextStyle(
            //height: 2,
            fontSize: 18, 
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always, labelText: label,
          hintText: placeholder,
          hintStyle: TextStyle(fontSize: 16),
          suffixIcon: suffixIcon
        )
      ))
      );

  }

  Widget formDropdown(String label, String name, List<DropdownMenuItem<String>> items, {
    IconData? icon, 
    String? validations, 
    bool isRequired = true,
    String? optionalText,
    String? value,
    void Function(String?)? onChanged,
    Color colorIcon = FlatColors.v1White4,
    
  }) {
    if(!_formOpen.private.formEnabled.containsKey(name)) {
      _formOpen.private.formEnabled[name] = true;
      _formOpen.private.getSelectedDropdown[name] = value;
      _formOpen.private.getErrorDropdown[name] = false;
    }
    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Flexible(child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          DropdownButtonFormField(
            hint: Text(label),
            disabledHint: Text(label),
            value: _fmp.getSelectedDropdown(name, items) ?? value,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isDense: true,
            validator: (dynamic value) {
              _formOpen.private.getValue[name] = value;
              return validations != null ? _valid.setRules(value, label, validations, name: name) : null;
            },
            onChanged: !_fmp.enabledForm(name)! ? null : (dynamic value) {
              _formOpen.private.getSelectedDropdown[name] = value;
              setSelectedDropdown(name, value);
              if(onChanged != null) onChanged(value);
              return null;
            }, 
            items: _formOpen.private.formEnabled[name]! ? items : null,
          )
      ]),)
    );
  }

  Widget formCheckbox(String label, String name, {Function(bool?)? onChanged, String? optionalText, bool isRequired = true, IconData? icon, Color? colorIcon, String? validations}) {

    if(!_formOpen.private.isErrorForm.containsKey(name)) {
      _formOpen.private.isErrorForm[name] = false;
      _formOpen.private.formEnabled[name] = true;
      _validSelected.setRulesSingleCheck(name, validations, label);
    }
    
    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  fillColor: MaterialStateProperty.all(_formOpen.private.isErrorForm[name]! ? FlatColors.googleRed : null),
                  value: getCheckbox(name), 
                  onChanged: !_fmp.enabledForm(name)! ? null : (bool? changed) {
                    setCheckbox(name, changed);
                    if(changed!) _fmp.setErrorCheckbox(name, false);
                    if(onChanged != null) onChanged(changed);
                }),
              ),
              SizedBox(width: 10),
              Text(label)
            ],
          ),
          
          if(_formOpen.private.isErrorForm[name]!) Text(_validSelected.getError(name)!, style: TextStyle(color: FlatColors.googleRed))
        ],
      )
    );
  }

  Widget formCheckboxs(String name, {
    required List<String> labels, 
    Function(int, bool?)? onChanged, 
    String? optionalText, 
    bool isRequired = true, 
    IconData? icon, 
    Color? colorIcon,
    String? label,
    String? validations
  }) {

    assert(labels != null || labels.length != 0, "The property 'labels' is required");

    if(!_formOpen.private.isErrorForm.containsKey(name)) {
      _formOpen.private.isErrorForm[name] = false;
      _formOpen.private.formEnabled[name] = true;
      
      _validSelected.setRulesMultiCheck(name, validations, label ?? name, labels.length);

      List<bool?> dataChecked = [];
      labels.forEach((element) {
        dataChecked.add(false);
      });
      _formOpen.private.getCheckboxs[name] = dataChecked;
    }

    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          for(int i = 0; i < labels.length; i ++) InkWell(
            onTap: () {
              _fmp.setCheckedCheckboxs(name, i, !_fmp.getCheckedCheckboxs(name)![i]!);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    fillColor: MaterialStateProperty.all(_formOpen.private.isErrorForm[name]! ? FlatColors.googleRed : null),
                    value: _fmp.getCheckedCheckboxs(name)![i], 
                    onChanged: !_fmp.enabledForm(name)! ? null : (bool? changed) {

                      _fmp.setCheckedCheckboxs(name, i, changed);

                      if(onChanged != null) onChanged(i, changed);
                  }),
                ),
                SizedBox(width: 10),
                Text(labels[i])
              ],
            )
          ),
          
          if(_formOpen.private.isErrorForm[name]!) Text(_validSelected.getError(name)!, style: TextStyle(color: FlatColors.googleRed))
        ],
      )
    );
  }

  /// values :
  /// values = {
  ///   "Kerja Rodi"  : "kr",
  ///   "Kerja Kuli"  : "kl"
  /// }
  Widget formRadio(String name, {required List<FormRadioData> values, String? label, Function(String, String)? onChanged, String? optionalText, bool isRequired = true, IconData? icon, Color? colorIcon, String? validations}) {
    assert(values != null || values.length != 0, "The property 'values' is required");
    
    if(!_formOpen.private.getCheckedRadio.containsKey(name)) {
      _formOpen.private.isErrorForm[name] = false;
      _formOpen.private.formEnabled[name] = true;
      _validSelected.setRulesRadio(name, validations, label ?? name);

      _formOpen.private.getCheckedRadio[name] = new FormsSelectedRadio(
          isChecked: false,
          value: null,
          name: name
        );
    }
    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, child: Column(
      crossAxisAlignment : CrossAxisAlignment.start,
      children: [
        if(label != null) Text(label),
        for(var val in values) LabeledRadio(
            fillColor: MaterialStateProperty.all(_formOpen.private.isErrorForm[name]! ? FlatColors.googleRed : null),
            groupValue: getRadio(name).value, 
            label: val.label, 
            onChanged: !_fmp.enabledForm(name)! ? null : (String newValue) {
              _formOpen.private.isErrorForm[name] = false;
              setRadio(name, newValue);
              if(onChanged != null) onChanged(name, newValue);
            }, 
            padding: EdgeInsets.all(0), 
            value: val.value,
          ),
        // _foreach(values, (int i, FormRadioData data) {
        //   return LabeledRadio(
        //     groupValue: name, 
        //     label: data.label, 
        //     onChanged: (String value) {
        //       if(onChanged != null) onChanged(value);
        //     }, 
        //     padding: null, 
        //     value: data.value,
        //   );
        // }) 
        
        if(_formOpen.private.isErrorForm[name]! ) Text(_validSelected.getError(name)!, style: TextStyle(color: FlatColors.googleRed))
      ],
    ) );
  }

  /// getSelectedDropdown
  /// 
  /// Get value from Dropdown
  /// 
  /// return String;
  String? getSelectedDropdown(String name) => _formOpen.private.getSelectedDropdown.containsKey(name) ? _formOpen.private.getSelectedDropdown[name] : null;
  
  void setSelectedDropdown(String name, String? value) { 
    _formOpen.private.getSelectedDropdown[name] = value;
    Provider.of<ArjunaneModelForms>(context, listen: false).changeDropdown = { 
      _keyForms : 
      {
        name : value
      }
    };
  }
  FormsSelectedRadio getRadio(String name) {
    // if(_modelForms.getFormsRadio.containsKey(_keyForms) && _modelForms.getFormsRadio[_keyForms].containsKey(name)) {
    //   var radioValue = _modelForms.getFormsRadio[_keyForms][name];
    //   print("3. value dalam if : $radioValue");
    //   return new FormsSelectedRadio(value: radioValue, isChecked: true, name: name);
    // }
    
    var radio = _formOpen.private.getCheckedRadio[name]!;

    return new FormsSelectedRadio(isChecked: radio.isChecked, value: radio.value, name : name);
  } 

  void setRadio(String name, String value) {
    _formOpen.private.isErrorForm[name] = false;
    _validSelected.updateValueRadio(name, value);
    _formOpen.private.getValue[name] = value;
    _formOpen.private.getCheckedRadio[name] = new FormsSelectedRadio(isChecked: true, name: name, value: value);
    Provider.of<ArjunaneModelForms>(context, listen: false).changeRadio = {
      _keyForms : {
        name : value
      }
    };
  }

  FormsCheckboxData getCheckboxs(String name) {
    if(_formOpen.private.getCheckboxs.containsKey(name)) {
      int i = 0;
      Map<int, bool?> checked = {};
      Map<int, bool?> unchecked = {};
      _formOpen.private.getCheckboxs[name]!.forEach((isChecked) {
        if(isChecked!) checked[i] = isChecked;
        else unchecked[i] = isChecked;
        i++;
      });
      return new FormsCheckboxData(checked: checked, unchecked: unchecked);
    }
    
    return new FormsCheckboxData(checked: {}, unchecked: {});
  }

  set setLanguageValidation(String language) {
    _valid.setLanguageValidation = language;
    _validSelected.setLanguageValidation = language;
  }

  void setCheckboxs(String name, Map<int, bool> index) {
    _formOpen.private.isErrorForm[name] = false;
    _formOpen.private.getValue[name] = _formOpen.private.getCheckboxs[name];
    _fmp.setNullErrorCheckboxs(name);
    index.forEach((index, value) { 
      _validSelected.updateValueMultiCheck(name, index, value);
      _formOpen.private.getCheckboxs[name]![index] = value;
    });
    Provider.of<ArjunaneModelForms>(context, listen: false).setEmpty = "";
  }

  bool? getCheckbox(String name) => _formOpen.private.getValue.containsKey(name) ? _formOpen.private.getValue[name] : false;
  
  void setCheckbox(String name, bool? value) {
    _formOpen.private.isErrorForm[name] = false;
    _validSelected.updateValueSingleCheck(name, value);
    _formOpen.private.getValue[name] = value;
    
    Provider.of<ArjunaneModelForms>(context, listen: false).changeCheckbox = { 
      _keyForms : 
      {
        name : value
      }
    };
  }

  void setState(void Function() fn) {
    fn();
    Provider.of<ArjunaneModelForms>(context, listen: false).setEmpty = "";
  }

  void submit() {
    bool isValid = true;
    
    _formOpen.private.isErrorForm.forEach((name, value) {
      var getError = _validSelected.getError(name);
      if(getError != null) isValid = false;
      _formOpen.private.isErrorForm[name] = getError != null;
    });
    // _formOpen.private.isCheckboxRequired.forEach((name, isRequired) {
    //   if(isRequired && !getCheckbox(name)) {
    //     isValid = false;
    //     //_setErrorCheckbox(name, true);
    //     _formOpen.private.getErrorCheckbox[name] = true;
    //     return;
    //   }
    //   else {
    //     //_setErrorCheckbox(name, false);
    //     _formOpen.private.getErrorCheckbox[name] = false;
    //   }
    // });
    // _formOpen.private.isRadioRequired.forEach((name, value) {
    //   var form = _formOpen.private.getCheckedRadio[name];
    //   if(!form.isChecked) {
    //     isValid = false;
    //     _formOpen.private.getErrorRadio[name] = true;
    //     //_setErrorRadio(name, true);
    //     return;
    //   }
    //   else { 
    //     _formOpen.private.getErrorRadio[name] = false;
    //     //_setErrorRadio(name, false);
    //   }
    // });
    

    if(!isValid) {Provider.of<ArjunaneModelForms>(context, listen: false).setEmpty = "Mencoba";}

    _formOpen.private.validate = isValid && _globalKey.currentState!.validate();
    
    _onSubmit(_fr);
  }

  void setTextEditingController(String name, String? value) {
    if(_formOpen.private.inputController != null && _formOpen.private.inputController.containsKey(name)) _formOpen.private.inputController[name]!.text = value!;
    else _formOpen.private.inputController[name] = TextEditingController(text: value);
    _formOpen.private.getValue[name] = value;
  }

  TextEditingController? getTextEditingController(String name) =>
    _formOpen.private.inputController.containsKey(name) ? _formOpen.private.inputController[name] : null;
  
  String get getKeyForms => _keyForms;

  bool? get getEnabled => !_modelForms.getEnabledForms.containsKey(_keyForms) ? true : _modelForms.getEnabledForms[_keyForms];

  void setErrorMessage(String name, String text) {
    _valid.setErrorMessage(name, text);
    _validSelected.setErrorMessage(name, text);
  }

  FormsWidget? get formWidget => _formWidget;

  void disabledForm({List<String>? only, List<String>? except}) {
    if(only != null) {
      only.forEach((name) {
        if(_formOpen.private.formEnabled.containsKey(name))_formOpen.private.formEnabled[name] = false;
      });
      return;
    }
    else if(except != null) {
      except.forEach((name) {
        if(_formOpen.private.formEnabled.containsKey(name))_formOpen.private.formEnabled[name] = false;
      });
      return;
    }
    _formOpen.private.formEnabled.forEach((name, value) {
      _formOpen.private.formEnabled[name] = false;
    });
  }

  static FormsWidget form(FormsWidget formWidgetOther) => formWidgetOther;
}