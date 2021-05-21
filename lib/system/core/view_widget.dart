import 'package:flutter/cupertino.dart';
import '../helper/helper.dart';
import 'models/arjunane_model_view_widget.dart';
import 'view_widget_event.dart';
import 'package:provider/provider.dart';

class ViewWidget extends StatefulWidget {

  final String id = Helper.randomString();

  final Key? key;
  final Widget Function(ViewWidgetEvent)? child;

  ViewWidget({this.key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewWidget();
}

class _ViewWidget extends State<ViewWidget> {

  late ViewWidgetEvent property;

  String? previousId;

  @override
  void initState() {

    property = ViewWidgetEvent(context, widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ArjunaneModelViewWidget, String?>(
      selector: (_, data) {
        if(data.getId != null && data.getId!.split("-")[0] == widget.id) previousId = data.getId;
        return data.getId != null && data.getId!.split("-")[0] == widget.id ? data.getId : previousId;
      },
      builder: (ctx, data, _) {
        return widget.child!(property);
      }
    );
  }

}