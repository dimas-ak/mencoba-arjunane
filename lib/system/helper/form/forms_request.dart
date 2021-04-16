import '../../../system/arjunane.dart';

import '../../../system/core/models/arjunane_model_forms.dart';
import 'package:provider/provider.dart';

class FormsRequest {

  final FormOpenState _formOpen;

  FormsRequest(this._formOpen);

  dynamic getValue(String name) => _formOpen.private.getValue[name];

  Map<String, dynamic> all({List<String> only, List<String> except}) {
    Map<String, dynamic> newFields = new Map<String, dynamic>();
    if(only != null && only.length > 0)
    {
      only.forEach((e) {
        if(_formOpen.private.getValue.containsKey(e)) newFields[e] = _formOpen.private.getValue[e];
      });
      return newFields;
    }
    else if(only != null && except.length > 0)
    {
      except.forEach((e) {
        if(_formOpen.private.getValue.containsKey(e)) newFields[e] = _formOpen.private.getValue[e];
      });
      return newFields;
    }
    return _formOpen.private.getValue;
  }
  
  bool get validate => _formOpen.private.validate;

  void setEnabled(bool enabled, {List<String> only, List<String> except}) { 
    if(only != null) {
      only.forEach((name) {
        if(_formOpen.private.formEnabled.containsKey(name))_formOpen.private.formEnabled[name] = enabled;
      });
    }
    else if(except != null) {
      except.forEach((name) {
        if(_formOpen.private.formEnabled.containsKey(name))_formOpen.private.formEnabled[name] = enabled;
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