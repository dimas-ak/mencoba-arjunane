import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/models/arjunane_model_alerts_widget.dart';
import 'package:provider/provider.dart';
import '../flat_colors.dart';
import '../helper.dart';
import 'components_alerts_type.dart';

class AlertsWidget extends StatefulWidget {
  final String title;
  final String message;
  final AlertsWidgetType alertsWidgetType;
  final TypeAlertDialog typeAlertDialog;
  final bool Function() onClose;
  final Widget child;
  final Key key;

  AlertsWidget(
      {@required this.title,
      @required this.message,
      this.typeAlertDialog = TypeAlertDialog.info,
      this.alertsWidgetType = AlertsWidgetType.box,
      this.child,
      this.onClose,
      this.key}) : super(key : key);

  AlertsWidgetHelper _init() {
    AlertsWidgetHelper widget;
    if (typeAlertDialog == TypeAlertDialog.info)
      widget = new AlertsWidgetHelper(
          color: FlatColors.googleBlue,
          icon: Icons.info_outline,
          title: title == null ? "Info" : title,
          message: message == null ? "Message" : message);
    else if (typeAlertDialog == TypeAlertDialog.danger)
      widget = new AlertsWidgetHelper(
          color: FlatColors.googleRed,
          icon: Icons.cancel,
          title: title == null ? "Info" : title,
          message: message == null ? "Message" : message);
    else if (typeAlertDialog == TypeAlertDialog.success)
      widget = new AlertsWidgetHelper(
          color: FlatColors.googleGreen,
          icon: Icons.check_circle,
          title: title == null ? "Info" : title,
          message: message == null ? "Message" : message);
    else if (typeAlertDialog == TypeAlertDialog.warning)
      widget = new AlertsWidgetHelper(
          color: FlatColors.googleYellow,
          icon: Icons.warning_amber_sharp,
          title: title == null ? "Info" : title,
          message: message == null ? "Message" : message);
    return widget;
  }

  @override
  _AlertsWidgetState createState() => _AlertsWidgetState();
}

class _AlertsWidgetState extends State<AlertsWidget> {
  String keys = Helper.randomString();

  bool isClose = false;

  @override
  Widget build(BuildContext context) {
    var init = widget._init();
    return Consumer<ArjunaneModelAlertsWidget>(builder: (ctx, data, _) {
      if (isClose && data.getKeyAlertsWidget == keys || isClose) return Container();
      if (widget.alertsWidgetType == AlertsWidgetType.rectangle) {
        return Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
                border: Border.all(color: FlatColors.v1White, width: 1)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 50,
                  child: Icon(init.icon, color: init.color),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        init.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: init.color),
                      ),
                      Text(init.message),
                      widget.child != null ? widget.child : Container()
                    ],
                  ),
                ),
                Container(
                    width: 50,
                    child: TextButton(
                        onPressed: () {
                          if (widget.onClose != null)
                            isClose = widget.onClose();
                          else
                            isClose = true;

                          print("================ $keys ===============");
                          if (isClose) closeAlert(keys);
                        },
                        child: Text("X")))
              ],
            ));
      }

      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            border: Border.all(color: FlatColors.v1White, width: 1)),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                Center(child: Icon(init.icon, size: 75, color: init.color)),
                Positioned(
                    right: 0,
                    child: TextButton(
                        onPressed: () {
                          if (widget.onClose != null)
                            isClose = widget.onClose();
                          else
                            isClose = true;

                          if (isClose) closeAlert(keys);
                        },
                        child: Text("X"))),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Text(
                  init.title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: init.color),
                ),
                Text(init.message),
                widget.child != null ? widget.child : Container()
              ])),
        ]),
      );
    });
  }

  void closeAlert(String _keys) {
    Provider.of<ArjunaneModelAlertsWidget>(context, listen: false).changeAlertsWidget =
        _keys;
  }
}

enum AlertsWidgetType { box, rectangle }

class AlertsWidgetHelper {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  AlertsWidgetHelper({this.icon, this.color, this.title, this.message});
}
