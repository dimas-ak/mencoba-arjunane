import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../system/helper/helper.dart';

class Forms {
  Map<String, TextEditingController> _inputController = new Map<String, TextEditingController>();
  Map<String, String> _getSelectedDropdown = new Map<String, String>();
  // Map<String, bool> _getCheckedCheckBox = new Map<String, bool>();
  Map<int, GlobalKey<FormState>> _keys = new Map<int, GlobalKey<FormState>>();

  int _indexKey = 0;

  Widget formOpen({Widget child, int indexKey = 0}) {
    _keys[indexKey] = new GlobalKey<FormState>();
    return Form(
      key: _keys[indexKey],
      child: child
    );
  }

  Widget formInput(String label, String key, {
    String placeholder,
    IconData icon = Icons.input, 
    String Function(String) validator, 
    bool enabled = true, 
    bool obscureText = false, 
    bool isRequired = true,
    String optionalText,
    bool readonly = false,
    Function onTap,
    bool isTextArea = false,
    TextInputType keyboardType = TextInputType.text, 
    void Function(String) onChanged,
    String colorIcon = "#7f8c8d"
  }) {
    
    return _containerForm(label, placeholder, optionalText, isRequired, icon, colorIcon, 
      child: Flexible(
        child: TextFormField(
        onTap: onTap,
        maxLines: isTextArea ? 8 : 1,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: getController(key),
        readOnly: readonly,
        validator: validator,
        style: TextStyle(fontSize: 16),
        enabled: enabled,
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

  Widget formCheckBox(bool value, String text, String key, {Function onChanged}) {
    return CheckboxListTile(
      value: value, 
      selected: value,
      title: Text(text),
      secondary: Text("Secondary"),
      onChanged: (val) {

      });
  }

  /// getSelectedDropdown
  /// 
  /// Get value from Dropdown
  /// 
  /// return String;
  String getSelectedDropdown(String key) {
    return _getSelectedDropdown[key];
  }

  Widget formDropdown(String label, String key, List<DropdownMenuItem<String>> items, {
    String placeholder,
    IconData icon = Icons.input, 
    String Function(String) validator, 
    bool isRequired = true,
    String optionalText,
    bool readonly,
    String value,
    void Function(String) onChanged,
    String colorIcon = "#7f8c8d",
    
  }) {

    return _containerForm(label, placeholder, optionalText, isRequired, icon, colorIcon, 
      child: Flexible(child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          DropdownButtonFormField(
            hint: Text(label),
            value: value,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            validator: validator,
            onChanged: (value) {
              _getSelectedDropdown[key] = value;
              if(onChanged != null) onChanged(value);
            }, 
            items: items,
          )
      ]),)
    );
  }

  Widget _containerForm(String label, String placeholder, String optionalText, bool isRequired, IconData icon, String colorHex, {Widget child}) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon( icon, color: Helper.fromHex(colorHex)),
              isRequired ? Text("*", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Helper.fromHex("#e74c3c"))) : Container(),
              SizedBox(width: 10),
              child
            ],
          ),
          optionalText != null ? Text(optionalText) : Container(),
          SizedBox(height: 10)
        ]
      )
    );
  }

  void setController(String key, String value) {

    if(_inputController.keys.contains(key)) _inputController[key].text = value;
    else _inputController[key] = new TextEditingController(text: value);
  }

  TextEditingController getController(String key) {
    return _inputController.containsKey(key) && (_inputController[key].text != null || _inputController[key].text.isNotEmpty) ? _inputController[key] : null;
  }

  bool validate({int indexKey = 0}) {
    _indexKey = indexKey;
    return _keys[indexKey].currentState.validate();
  }

  int get indexKey => _indexKey;

  void dispose() {
    _inputController.forEach((key, value) {
      value.dispose();
    });
  }
}