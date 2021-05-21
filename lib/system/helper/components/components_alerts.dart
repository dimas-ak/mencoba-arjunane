import 'package:flutter/material.dart';
import '../helper.dart';

import '../flat_colors.dart';
import 'components_alerts_type.dart';
import 'components_buttons.dart';
import 'components_standards.dart';
import 'components_type_style.dart';

class AlertsContainer extends StatelessWidget
{
  final String? text;
  final String? title;
  final TypeStyle style;
  final Widget Function(_AlertContainerHelper)? child;

  AlertsContainer(this.text, {
    Key? key,
    this.title,
    this.style = TypeStyle.primary,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _child;

    var colors = _getStyleAlertContainer(style)!;

    if(child == null) {
      _child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title == null ? Container() : heading(title!, fontColor: colors.textColor, typeHeader: TypeHeader.h3),
          title == null ? Container() : Divider( color: colors.textColor ),
          Text(text!, style: TextStyle(color: colors.textColor))
        ],
      );
    } else _child = child!(colors);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 2, color: colors.borderColor!),
        color: colors.backgroundColor
      ),
      child: _child
    );
  }
  
}

Future<Widget?> showLoadingDialog({
  required BuildContext context,
  String title = "Loading", 
  String message = "Sedang diproses ...", 
  Color color = FlatColors.googleBlue, 
  bool dismissible = false,
  Function? cancelAction,
  String? cancelText
}) async {
  return await _alertDialog(context, dismissible, title, message, 
  children: [
    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    SizedBox(height: 10),
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color)
    ),
    SizedBox(height: 10),
    Expanded(
      child: SingleChildScrollView(
        child: Text(message),
    ))
  ], actions: [
    cancelText != null ? TextButton(child: Text(cancelText), onPressed: () {
      closeDialog(context);
      if(cancelAction != null) cancelAction();
    }) : Container()
  ]);
}

void closeDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

Future<bool> showConfirmDialog({
  required BuildContext context, 
  required String message, 
  Function? yesConfirm, 
  String title = "Info", 
  String textYes = "Yes", 
  String textNo = "No", 
  Function? noConfirm, 
  /// Default : TypeAlertDialog.info
  TypeAlertDialog typeAlertDialog = TypeAlertDialog.info,
  bool dismissible = true
}) async {

  var icon = _getIcon(typeAlertDialog);
  bool confirm = false;
  await _alertDialog(context, dismissible, title, message, icon : icon, 
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Text(message),
        ))
      ], actions: [
        TextButton(
          child: Text(textNo), 
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            if(noConfirm != null) noConfirm();
        }),
        Buttons(textYes, onPressed: () {
          confirm = true;
          Navigator.of(context, rootNavigator: true).pop();
          if(yesConfirm != null) yesConfirm();
        })
  ]);
  return confirm;
}

Future<Widget?> showAlertDialog({
  required BuildContext context,
  required String message,
  TypeAlertDialog typeAlertDialog = TypeAlertDialog.info,
  String title = "INFO",
  String textButton = "OK",
  bool dismissible = true,
  Function? onOk
}) async {

  var icon = _getIcon(typeAlertDialog);
  return _alertDialog(context, dismissible, title, message, icon : icon, 
  children: [
    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    SizedBox(height: 10),
    Expanded(
      child: SingleChildScrollView(
        child: Text(message),
    ))
  ], actions: [
    TextButton(
      child: Text(textButton),
      onPressed: () {
        closeDialog(context);
        if(onOk != null) onOk();
    })
  ]);
}

Future<Widget?> _alertDialog(BuildContext context, bool dismissible, String title, String text, { _AlertHelper? icon, List<Widget>? children, List<Widget>? actions}) async {

  return await showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: dismissible,
    barrierLabel: '',
    transitionBuilder: (ctx, anim1, anim2, widget) {
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              height: 200,
              child: Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: icon != null ? 35 : 10),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: children!),
                  ),
                  icon != null ? Positioned(
                    left: 0, right:0, top: -45,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                      ),
                      child: Icon( icon.icon,
                        color: Helper.fromHex(icon.color!),
                        size: 65,
                      ),
                    ),
                  ) : Container()
                ],
              ),
            ),
            actions: actions)
        )
      );
    }, pageBuilder: ((BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => null) as Widget Function(BuildContext, Animation<double>, Animation<double>)
  );
  
}

_AlertHelper _getIcon(TypeAlertDialog type) {
  var icon;
  if(type == TypeAlertDialog.danger) icon = new _AlertHelper(color: "#ff5252", icon: Icons.cancel);
  else if(type == TypeAlertDialog.warning) icon = new _AlertHelper(color: "#ffb142", icon: Icons.error);
  else if(type == TypeAlertDialog.success) icon = new _AlertHelper(color: "#26de81", icon: Icons.check_circle);
  else icon = new _AlertHelper(color: "#4b7bec", icon: Icons.info);

  return icon;
}
_AlertContainerHelper? _getStyleAlertContainer(TypeStyle type) {

  _AlertContainerHelper? ini;

  // primary
  if(type == TypeStyle.primary) ini = new _AlertContainerHelper(
      textColor: FlatColors.sweedishBlue,
      borderColor: FlatColors.googleBlue2,
      backgroundColor: FlatColors.googleBlue3
    );
  // danger
  else if(type == TypeStyle.danger) ini = new _AlertContainerHelper(
      textColor: FlatColors.v1Red2,
      borderColor: FlatColors.googleRed2,
      backgroundColor: FlatColors.googleRed3
    );
  // dark
  else if(type == TypeStyle.dark) ini = new _AlertContainerHelper(
      textColor: Colors.white,
      borderColor: FlatColors.googleBlack2,
      backgroundColor: FlatColors.googleBlack3
    );
  // info
  else if(type == TypeStyle.info) ini = new _AlertContainerHelper(
      textColor: FlatColors.sweedishBlue2,
      borderColor: FlatColors.germanBlue,
      backgroundColor: FlatColors.googleBlue2
    );
  // light
  else if(type == TypeStyle.light) ini = new _AlertContainerHelper(
      textColor: FlatColors.googleBlack,
      borderColor: FlatColors.googleWhite3,
      backgroundColor: FlatColors.googleWhite2
    );
  // secondary
  else if(type == TypeStyle.secondary) ini = new _AlertContainerHelper(
      textColor: FlatColors.googleBlack,
      borderColor: FlatColors.v1White3,
      backgroundColor: FlatColors.v1White3
    );
  // success
  else if(type == TypeStyle.success) ini = new _AlertContainerHelper(
      textColor: FlatColors.spanishGreen2,
      borderColor: FlatColors.germanGreen3,
      backgroundColor: FlatColors.googleGreen3
    );
  // warning
  else if(type == TypeStyle.warning) ini = new _AlertContainerHelper(
      textColor: FlatColors.v1YOrange2,
      borderColor: FlatColors.googleYellow2,
      backgroundColor: FlatColors.googleYellow3
    );
  return ini;
}

class _AlertContainerHelper {
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  _AlertContainerHelper({this.textColor, this.borderColor, this.backgroundColor});
}

class _AlertHelper {
  final String? color;
  final IconData? icon;
  _AlertHelper({this.color, this.icon});
}