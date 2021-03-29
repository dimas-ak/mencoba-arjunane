import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helper/flat_colors.dart';
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

  Widget formInput(String label, String name, {
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
    Color colorIcon = FlatColors.v1White4
  }) {
    
    return _containerForm(label, placeholder, optionalText, isRequired, icon, colorIcon, 
      child: Flexible(
        child: TextFormField(
        onTap: onTap,
        maxLines: isTextArea ? 8 : 1,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: getController(name),
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
  String getSelectedDropdown(String name) {
    return _getSelectedDropdown[name];
  }

  Widget formDropdown(String label, String name, List<DropdownMenuItem<String>> items, {
    String placeholder,
    IconData icon = Icons.input, 
    String Function(String) validator, 
    bool isRequired = true,
    String optionalText,
    bool readonly,
    String value,
    void Function(String) onChanged,
    Color colorIcon = FlatColors.v1White4,
    
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
              _getSelectedDropdown[name] = value;
              if(onChanged != null) onChanged(value);
            }, 
            items: items,
          )
      ]),)
    );
  }

  Widget _containerForm(String label, String placeholder, String optionalText, bool isRequired, IconData icon, Color colorHex, {Widget child}) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon( icon, color: colorHex),
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

  void setController(String name, String value) {

    if(_inputController.keys.contains(name)) _inputController[name].text = value;
    else _inputController[name] = new TextEditingController(text: value);
  }

  TextEditingController getController(String name) {
    return _inputController.containsKey(name) && (_inputController[name].text != null || _inputController[name].text.isNotEmpty) ? _inputController[name] : null;
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