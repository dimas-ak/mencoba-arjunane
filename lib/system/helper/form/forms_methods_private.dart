import 'package:flutter/material.dart';
import '../../../system/arjunane.dart';
import '../../../system/core/models/arjunane_model_forms.dart';
import '../../../system/helper/form/forms_widget.dart';
import 'package:provider/provider.dart';

class FormsMethodsPrivate {

  final FormsWidget _formsWidget;

  final FormOpenState _formOpen;

  FormsMethodsPrivate(this._formsWidget, this._formOpen);

  void onTapDatePicker(String name, String Function(DateTime)? customDateFormat) async {
    try{
      String? value = _formOpen.private.getValue[name];
      DateTime _date = value == null || value.isEmpty ? DateTime.now() : DateTime.parse(value);
        
      var picker = await showDatePicker(context: _formOpen.context, initialDate: _date, firstDate: DateTime(2015, 8), lastDate: DateTime(2101, 8));
      if(picker != null) {
        String date = customDateFormat == null ? picker.toLocal().toString().split(" ")[0] : customDateFormat(picker);
        _formsWidget.setTextEditingController(name, date);
        Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).changeDatePicker = {
          _formsWidget.getKeyForms : {
            name : date
          }
        };
      }
    }
    catch (e){}
    
  }

  String? getSelectedDropdown(String name, List<DropdownMenuItem<String>> items) {
    String? isFind;
    String? value = _formOpen.private.getSelectedDropdown[name];
    items.forEach((element) {
      if(value != null && element.value!.contains(value)) isFind = element.value;
    });
    return isFind ?? null;
  }

  bool? enabledForm(String name) => _formOpen.private.formEnabled[name];

  bool? getErrorDropdown(String name) => _formOpen.private.getErrorDropdown[name];

  void setErrorCheckbox(String name, bool value) {
    _formOpen.private.isErrorForm[name] = value;
    Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).changeErrorCheckbox = {
      _formsWidget.getKeyForms : {
        name : value
      }
    };
  }
  
  void setErrorRadio(String name, bool value) {
    _formOpen.private.isErrorForm[name] = value;
    Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).changeErrorRadio = {
      _formsWidget.getKeyForms : {
        name : value
      }
    };
  }

  void setNullErrorCheckboxs(String name) {
    _formOpen.private.isErrorForm[name] = false;
  }

  List<bool?>? getCheckedCheckboxs(String name) => _formOpen.private.getCheckboxs.containsKey(name) ? _formOpen.private.getCheckboxs[name] : [];

  void setCheckedCheckboxs(String name, int index, bool? value) {
    _formOpen.private.getCheckboxs[name]![index] = value;
    setNullErrorCheckboxs(name);
    _formOpen.private.getValue[name] = _formOpen.private.getCheckboxs[name];
    Provider.of<ArjunaneModelForms>(_formOpen.context, listen: false).setEmpty = "";
  }

  
  Widget containerForm(String? optionalText, bool isRequired, IconData? icon, Color? colorHex, {Widget? child}) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(icon != null) Container(
                margin: EdgeInsets.only(top: 5),
                child: Icon( icon, color: colorHex)
              ),
              if(isRequired) Text("*", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Helper.fromHex("#e74c3c"))),
              SizedBox(width: 10),
              child!
            ],
          ),
          if(optionalText != null) Padding(
            padding: EdgeInsets.only(left: icon != null ? 40 : 20, top: 10),
            child: Text(optionalText, style: TextStyle(color: FlatColors.v1White4),),
          ),
          SizedBox(height: 10)
        ]
      )
    );
  }
}