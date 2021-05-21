import '../../../system/arjunane.dart';

import '../../../system/core/models/arjunane_model_forms.dart';
import 'package:provider/provider.dart';

import 'forms_selected_radio.dart';

class FormsRequest {

  final FormOpenState _formOpen;

  FormsRequest(this._formOpen);

  dynamic getValue(String name) => _formOpen.private.getValue[name];

  _setNullDropdown(String name) => _formOpen.private.getSelectedDropdown.containsKey(name) ? _formOpen.private.getSelectedDropdown[name] = null : null;
  
  _setNullInput(String name) => _formOpen.private.inputController.containsKey(name) ? _formOpen.private.inputController[name]!.clear() : null;
  
  _setNullCheckbox(String name) {
    if(_formOpen.private.getValue.containsKey(name)) {
      _formOpen.private.getValue[name] = false;
    }
  }

  _setNullRadio(String name) {
    if(_formOpen.private.getCheckedRadio.containsKey(name)) {
      _formOpen.private.getValue[name] = null;
      _formOpen.private.getCheckedRadio[name] = new FormsSelectedRadio(isChecked: false, name: name, value: null);
    }
  }

  _setNullCheckboxs(String name) {
    if(_formOpen.private.getCheckboxs.containsKey(name)) {
      int i = 0;
      _formOpen.private.getCheckboxs[name]!.forEach((isChecked) {
        _formOpen.private.getCheckboxs[name]![i] = false;
        i++;
      });
    }
  }

  void setState(void Function() fn) {
    fn();
    Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).setEmpty = "";
  }
  
  _setNull(String name) {
    _setNullCheckbox(name);
    _setNullCheckboxs(name);
    _setNullDropdown(name);
    _setNullInput(name);
    _setNullRadio(name);
  }

  void setNullValue({List<String>? only, List<String>? except}) {
    if(only != null && only.length > 0) {
      only.forEach((name) {
        if(_formOpen.private.getValue.containsKey(name)) _setNull(name);
      });
    }
    else if(except != null && except.length > 0) {
      _formOpen.private.getValue.forEach((name, value) {
        if(!except.contains(name)) _setNull(name);
      });
    }
    else {
      _formOpen.private.getValue.forEach((name, value) {
        _setNull(name);
      });
    }
    Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).setEmpty = "";
  }
  
  Map<String, dynamic> all({List<String>? only, List<String>? except}) {
    Map<String, dynamic> newFields = {};
    if(only != null && only.length > 0)
    {
      only.forEach((e) {
        if(_formOpen.private.getValue.containsKey(e)) newFields[e] = _formOpen.private.getValue[e];
      });
      return newFields;
    }
    else if(except != null && except.length > 0)
    {
      _formOpen.private.getValue.forEach((name, value) {
        if(!except.contains(name)) newFields[name] = _formOpen.private.getValue[name];
      });
      return newFields;
    }
    return _formOpen.private.getValue;
  }
  
  bool? get validate => _formOpen.private.validate;

  void setEnabled(bool enabled, {List<String>? only, List<String>? except}) { 
    if(only != null && only.length > 0) {
      only.forEach((name) {
        if(_formOpen.private.formEnabled.containsKey(name))_formOpen.private.formEnabled[name] = enabled;
      });
    }
    else if(except != null && except.length > 0) {
      _formOpen.private.formEnabled.forEach((name, value) {
        if(!except.contains(name)) _formOpen.private.formEnabled[name] = enabled;
      });
    }
    else {
      _formOpen.private.formEnabled.forEach((name, value) {
        if(_formOpen.private.formEnabled.containsKey(name))_formOpen.private.formEnabled[name] = enabled;
      });
    }
    Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).changeEnabledForms = {_formOpen.widget.keyForms : enabled};
  }

}