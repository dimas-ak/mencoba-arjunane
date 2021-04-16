import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../system/helper/form/forms_data_private.dart';
import '../../../system/helper/form/forms_widget.dart';
import '../../core/models/arjunane_model_forms.dart';
import 'package:provider/provider.dart';
import '../helper.dart';
import 'forms_request.dart';

class FormOpen extends StatefulWidget {

  final Widget Function(FormsWidget) child;

  final void Function(FormsRequest) onSubmit;

  final void Function(FormsWidget) onInit;

  final globalKey = GlobalKey<FormState>();

  final String keyForms = Helper.randomString();

  FormOpen({@required this.child, @required this.onSubmit, this.onInit, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FormOpenState();
  
}

class FormOpenState extends State<FormOpen> {
  
  FormsDataPrivate private = new FormsDataPrivate();

  bool _isFirst = true;
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isFirst = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    private.inputController.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.globalKey,
      child: Consumer<ArjunaneModelForms>(
        builder: (ctx, data, _) {
          return widget.child(FormsWidget(
            context, // context
            widget.globalKey, //Global Key
            this,
            widget.onSubmit, // on Submit
            widget.onInit, // on Init
            _isFirst,
            data,
            widget.keyForms
        ));
        },
      )
    );
  }

}