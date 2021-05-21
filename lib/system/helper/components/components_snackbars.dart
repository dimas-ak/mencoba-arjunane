import 'package:flutter/material.dart';
import '../font_size.dart';
import '../flat_colors.dart';
import 'components_type_style.dart';

void snackBar(BuildContext context, String text, {
  String? title, 
  List<Widget>? actions,
  TypeStyle style = TypeStyle.light,
  Widget Function(_SnackBarHelper)? child,
  int milliseconds = 5000
}) { 
  var colors = _getSnackbarStyle(style)!;
  Widget _child;
  if(child == null) {

    _child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        title != null ? Text(title, style: TextStyle(color: colors.textColor, fontSize: FontSize.large)) : Container(),
        title != null ? Divider(color: colors.dividerColor) : Container(),

        Text(text, style: TextStyle(color: colors.textColor)),

        actions != null ? Divider(color: colors.dividerColor) : Container(),
        actions != null ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: actions ) : Container()
      ],
    );
  }
  else _child = child(colors);

  final snackBar = SnackBar(

    duration: Duration(milliseconds: milliseconds),
    padding: EdgeInsets.all(5),
    elevation: 0,
    backgroundColor: Colors.black.withOpacity(0.0),
    content: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: colors.backgroundColor
      ),
      child: _child,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // Scaffold.of(context).showSnackBar(snackBar);
}

void snackBarClose(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  // Scaffold.of(context).removeCurrentSnackBar();
}

_SnackBarHelper? _getSnackbarStyle(TypeStyle style) {
  var ini;

  //light
  if(style == TypeStyle.light) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleWhite,
      dividerColor: FlatColors.googleBlack3,
      textColor : FlatColors.googleBlack
    );
  // danger
  else if(style == TypeStyle.danger) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleRed,
      dividerColor: Colors.white,
      textColor : Colors.white
    );
  // dark
  else if(style == TypeStyle.dark) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleBlack,
      dividerColor: Colors.white,
      textColor : Colors.white
    );
  // info
  else if(style == TypeStyle.info) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.germanBlue,
      dividerColor: FlatColors.googleBlack,
      textColor : FlatColors.googleBlack
    );
  // primary
  else if(style == TypeStyle.primary) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleBlue,
      dividerColor: Colors.white,
      textColor : Colors.white
    );
  // secondary
  else if(style == TypeStyle.secondary) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleBlack2,
      dividerColor: Colors.white,
      textColor : Colors.white
    );
  // success
  else if(style == TypeStyle.success) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleGreen,
      dividerColor: Colors.white,
      textColor : Colors.white
    );
  // warning
  else if(style == TypeStyle.warning) ini = new _SnackBarHelper(
      backgroundColor: FlatColors.googleYellow,
      dividerColor: Colors.white,
      textColor : Colors.white
    );

  return ini;
}

class _SnackBarHelper {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? dividerColor;
  _SnackBarHelper({this.backgroundColor, this.textColor, this.dividerColor});
}