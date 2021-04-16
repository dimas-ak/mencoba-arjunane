import 'package:flutter/material.dart';
import '../../../system/helper/components/components_labeled_radio.dart';
import '../../../system/helper/form/forms_methods_private.dart';
import 'package:provider/provider.dart';
import '../../../system/core/models/arjunane_model_forms.dart';
import '../../../system/helper/form/forms_request.dart';
import '../../../system/helper/form/forms.dart';

import '../../library/validation.dart';
import '../flat_colors.dart';
import 'forms_checkbox_data.dart';
import 'forms_checkboxs_error.dart';
import 'forms_radio_data.dart';
import 'forms_selected_radio.dart';

class FormsWidget {

  Validation _valid = new Validation();

  final GlobalKey<FormState> _globalKey;

  final void Function(FormsRequest) _onSubmit;

  final void Function(FormsWidget) _onInit;

  FormsRequest _fr;

  FormsMethodsPrivate _fmp;

  final BuildContext context;

  final bool _isFirst;

  FormsWidget _formWidget;

  final String _keyForms;

  final FormOpenState _formOpen;

  final ArjunaneModelForms _modelForms;

  FormsWidget(this.context, this._globalKey, this._formOpen, this._onSubmit, this._onInit, this._isFirst, this._modelForms, this._keyForms) {

    assert(this._onSubmit != null, "The method 'onSubmit' is required at FormOpen.");
    _fmp = new FormsMethodsPrivate(this, _formOpen);
    _fr = new FormsRequest(_formOpen);

    _formWidget = this;
    if(_isFirst) WidgetsBinding.instance.addPostFrameCallback((_) {
      if(this._onInit != null) this._onInit(this);
    });
    
  }

  Widget formInput(String label, String name, {
    String placeholder,
    IconData icon, 
    String validations, 
    bool obscureText = false, 
    bool isRequired = true,
    String optionalText,
    bool readonly = false,
    Function onTap,
    bool isTextArea = false,
    TextInputType keyboardType = TextInputType.text, 
    void Function(String) onChanged,
    Color colorIcon = FlatColors.v1White4
  }) {
    if(!_formOpen.private.inputController.containsKey(name)) { 
      _formOpen.private.formEnabled[name] = true;
      setTextEditingController(name, null);
    }
    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Flexible(
        child: TextFormField(
        onTap: onTap,
        maxLines: isTextArea ? 8 : 1,
        obscureText: obscureText,
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
          hintStyle: TextStyle(fontSize: 16)
        )
      ))
      );

  }

  Widget formInputDatePicker(String label, String name, {
      @required DateTime firstDate,
      @required DateTime lastDate,
      String placeholder,
      IconData icon, 
      String validations, 
      bool isRequired = true,
      String optionalText,
      String Function(DateTime) customDateFormat,
      bool readonly = false,
      Function onTap,
      TextInputType keyboardType = TextInputType.datetime, 
      void Function(String) onChanged,
      Color colorIcon = FlatColors.v1White4
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
          hintStyle: TextStyle(fontSize: 16)
        )
      ))
      );

  }

  Widget formDropdown(String label, String name, List<DropdownMenuItem<String>> items, {
    IconData icon, 
    String validations, 
    bool isRequired = true,
    String optionalText,
    String value,
    void Function(String) onChanged,
    Color colorIcon = FlatColors.v1White4,
    
  }) {
    if(!_formOpen.private.formEnabled.containsKey(name)) {
      _formOpen.private.formEnabled[name] = true;
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
            value: !_modelForms.getFormsDropdown.containsKey(_keyForms) || !_modelForms.getFormsDropdown[_keyForms].containsKey(name) ? value : _modelForms.getFormsDropdown[_keyForms][name],
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isDense: true,
            validator: (value) {
              _formOpen.private.getValue[name] = value;
              return validations != null ? _valid.setRules(value, label, validations, name: name) : null;
            },
            onChanged: !_fmp.enabledForm(name) ? null : (value) {
              _formOpen.private.getSelectedDropdown[name] = value;
              setSelectedDropdown(name, value);
              if(onChanged != null) onChanged(value);
              return null;
            }, 
            items: !_modelForms.getEnabledForms.containsKey(_keyForms) || _modelForms.getEnabledForms[_keyForms] == true ? items : null,
          )
      ]),)
    );
  }

  Widget formCheckbox(String label, String name, {Function(bool) onChanged, String optionalText, bool isRequired = true, IconData icon, Color colorIcon, String errorMessage}) {
    
    errorMessage = errorMessage ?? "Harap centang Checkbox diatas.";

    if(!_formOpen.private.isCheckboxRequired.containsKey(name)) {
      if(isRequired)_formOpen.private.isCheckboxRequired[name] = isRequired;
      _formOpen.private.getErrorCheckbox[name] = false;
      _formOpen.private.formEnabled[name] = true;
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
                  fillColor: MaterialStateProperty.all(isRequired && _fmp.getErrorCheckbox(name) ? FlatColors.googleRed : null),
                  value: getCheckbox(name), 
                  onChanged: !_fmp.enabledForm(name) ? null : (bool changed) {
                    setCheckbox(name, changed);
                    if(changed) _fmp.setErrorCheckbox(name, false);
                    if(onChanged != null) onChanged(changed);
                }),
              ),
              SizedBox(width: 10),
              Text(label)
            ],
          ),
          
          if(isRequired && _fmp.getErrorCheckbox(name)) Text(errorMessage, style: TextStyle(color: FlatColors.googleRed))
        ],
      )
    );
  }

  Widget formCheckboxs(String name, {
    @required List<String> labels, 
    Function(int, bool) onChanged, 
    String optionalText, 
    bool isRequired = true, 
    IconData icon, 
    Color colorIcon, 
    String errorMessageRequired, 
    String label,
    int maxChecked,
    int minChecked,
    String errorMessageMaxChecked,
    String errorMessageMinChecked
  }) {

    assert(labels != null || labels.length != 0, "The property 'labels' is required");
    
    errorMessageRequired = errorMessageRequired ?? "Harap centang Checkbox diatas.";

    errorMessageMaxChecked = errorMessageMaxChecked ?? "Maksimal yang dicentang ialah $maxChecked.";
    
    errorMessageMinChecked = errorMessageMinChecked ?? "Minimal yang dicentang ialah $minChecked.";

    if(!_formOpen.private.checkboxsError.containsKey(name)) {
      _formOpen.private.checkboxsError[name] = new  FormsCheckboxsError(
        isErrorRequired: false,
        isErrorMax: false,
        isErrorMin: false,
        isSubmited: false,
        isRequired: isRequired,
        isMax: maxChecked != null ? true : false,
        isMin: minChecked != null ? true : false,
        max : maxChecked != null ? maxChecked : -1,
        min: minChecked != null ? minChecked : -1,
      );
      _formOpen.private.formEnabled[name] = true;

      List<bool> dataChecked = [];
      labels.forEach((element) {
        dataChecked.add(false);
      });
      _formOpen.private.getCheckboxs[name] = dataChecked;
    }
    
    var getError = _fmp.getErrorCheckboxs(name);

    return _fmp.containerForm(optionalText, isRequired, icon, colorIcon, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          for(int i = 0; i < labels.length; i ++) InkWell(
            onTap: () {
              _fmp.setCheckedCheckboxs(name, i, !_fmp.getCheckedCheckboxs(name)[i]);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    fillColor: MaterialStateProperty.all(getError.isSubmited && (getError.isErrorRequired || getError.isErrorMin || getError.isErrorMax) ? FlatColors.googleRed : null),
                    value: _fmp.getCheckedCheckboxs(name)[i], 
                    onChanged: !_fmp.enabledForm(name) ? null : (bool changed) {

                      _fmp.setCheckedCheckboxs(name, i, changed);

                      if(onChanged != null) onChanged(i, changed);
                  }),
                ),
                SizedBox(width: 10),
                Text(labels[i])
              ],
            )
          ),
          
          if(getError.isSubmited && getError.isErrorRequired) Text(errorMessageRequired, style: TextStyle(color: FlatColors.googleRed)),
          if(getError.isSubmited && getError.isErrorMax) Text(errorMessageMaxChecked, style: TextStyle(color: FlatColors.googleRed)),
          if(getError.isSubmited && getError.isErrorMin) Text(errorMessageMinChecked, style: TextStyle(color: FlatColors.googleRed)),
        ],
      )
    );
  }

  /// values :
  /// values = {
  ///   "Kerja Rodi"  : "kr",
  ///   "Kerja Kuli"  : "kl"
  /// }
  Widget formRadio(String name, {@required List<FormRadioData> values, String label, Function(String, String) onChanged, String optionalText, bool isRequired = true, IconData icon, Color colorIcon, String errorMessage}) {
    assert(values != null || values.length != 0, "The property 'values' is required");

    errorMessage = errorMessage ?? "Harap pilih Pilihan diatas.";

    if(!_formOpen.private.getCheckedRadio.containsKey(name)) {
      if(isRequired) _formOpen.private.isRadioRequired[name] = isRequired;
      
      _formOpen.private.getErrorRadio[name] = false;
      _formOpen.private.formEnabled[name] = true;

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
            fillColor: MaterialStateProperty.all(isRequired && _fmp.getErrorRadio(name) ? FlatColors.googleRed : null),
            groupValue: getRadio(name).value, 
            label: val.label, 
            onChanged: !_fmp.enabledForm(name) ? null : (String newValue) {
              _formOpen.private.getErrorRadio[name] = false;
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
        
        if(isRequired && _fmp.getErrorRadio(name) ) Text(errorMessage, style: TextStyle(color: FlatColors.googleRed))
      ],
    ) );
  }

  /// getSelectedDropdown
  /// 
  /// Get value from Dropdown
  /// 
  /// return String;
  String getSelectedDropdown(String name) => _formOpen.private.getSelectedDropdown.containsKey(name) ? _formOpen.private.getSelectedDropdown[name] : null;
  
  void setSelectedDropdown(String name, String value) { 
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
    
    var radio = _formOpen.private.getCheckedRadio[name];

    return new FormsSelectedRadio(isChecked: radio.isChecked, value: radio.value, name : name);
  } 

  void setRadio(String name, String value) {
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
      Map<int, bool> checked = {};
      Map<int, bool> unchecked = {};
      _formOpen.private.getCheckboxs[name].forEach((isChecked) {
        if(isChecked) checked[i] = isChecked;
        else unchecked[i] = isChecked;
        i++;
      });
      return new FormsCheckboxData(checked: checked, unchecked: unchecked);
    }
    
    return new FormsCheckboxData(checked: {}, unchecked: {});
  }

  void setCheckboxs(String name, Map<int, bool> index) {
    _formOpen.private.getValue[name] = _formOpen.private.getCheckboxs[name];
    _fmp.setNullErrorCheckboxs(name);
    index.forEach((index, value) => _formOpen.private.getCheckboxs[name][index] = value );
    Provider.of<ArjunaneModelForms>(context, listen: false).setEmpty = "";
  }

  bool getCheckbox(String name) => _formOpen.private.getValue.containsKey(name) ? _formOpen.private.getValue[name] : false;
  
  void setCheckbox(String name, bool value) {
    _formOpen.private.getValue[name] = value;
    _formOpen.private.isCheckboxRequired[name] = false;
    Provider.of<ArjunaneModelForms>(context, listen: false).changeCheckbox = { 
      _keyForms : 
      {
        name : value
      }
    };
  }

  void submit() {
    bool isValid = true;
    
    _formOpen.private.isCheckboxRequired.forEach((name, isRequired) {
      if(isRequired && !getCheckbox(name)) {
        isValid = false;
        //_setErrorCheckbox(name, true);
        _formOpen.private.getErrorCheckbox[name] = true;
        return;
      }
      else {
        //_setErrorCheckbox(name, false);
        _formOpen.private.getErrorCheckbox[name] = false;
      }
    });
    _formOpen.private.isRadioRequired.forEach((name, value) {
      var form = _formOpen.private.getCheckedRadio[name];
      if(!form.isChecked) {
        isValid = false;
        _formOpen.private.getErrorRadio[name] = true;
        //_setErrorRadio(name, true);
        return;
      }
      else { 
        _formOpen.private.getErrorRadio[name] = false;
        //_setErrorRadio(name, false);
      }
    });

    _formOpen.private.getCheckboxs.forEach((name, value) {

      var getValidation = _formOpen.private.checkboxsError[name];
      getValidation.isSubmited = true;
      _fmp.setNullErrorCheckboxs(name);

      if(getValidation.isRequired && getCheckboxs(name).checked.length == 0) _formOpen.private.checkboxsError[name].isErrorRequired = true;
      else if(getValidation.isMin && getValidation.min > getCheckboxs(name).checked.length) _formOpen.private.checkboxsError[name].isErrorMin = true;
      else if(getValidation.isMax && getCheckboxs(name).checked.length > getValidation.max) _formOpen.private.checkboxsError[name].isErrorMax = true;
    });

    if(!isValid) Provider.of<ArjunaneModelForms>(context, listen: false).setEmpty = "Mencoba";

    _formOpen.private.validate = isValid && _globalKey.currentState.validate();
    
    _onSubmit(_fr);
  }

  void setTextEditingController(String name, String value) {
    if(_formOpen.private.inputController != null && _formOpen.private.inputController.containsKey(name)) _formOpen.private.inputController[name].text = value;
    else _formOpen.private.inputController[name] = TextEditingController(text: value);
    _formOpen.private.getValue[name] = value;
  }

  TextEditingController getTextEditingController(String name) =>
    _formOpen.private.inputController.containsKey(name) ? _formOpen.private.inputController[name] : null;
  
  String get getKeyForms => _keyForms;

  bool get getEnabled => !_modelForms.getEnabledForms.containsKey(_keyForms) ? true : _modelForms.getEnabledForms[_keyForms];

  void setErrorMessageInput(String name, String text) => _valid.setErrorMessage(name, text);

  FormsWidget get formWidget => _formWidget;

  void disabledForm({List<String> only, List<String> except}) {
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

  static FormsWidget form(FormsWidget formWidget) => formWidget;
}