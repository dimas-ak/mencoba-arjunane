
import 'package:flutter/material.dart';

import '../flat_colors.dart';
import 'components_type_style.dart';


Widget button(String text, {Function onPressed, Function onLongPressed, TypeStyle style = TypeStyle.primary, IconData icon, bool isDisabled = false, bool isFullWidth = false}) {
  var color = _getStyleButton(style);
  var child;

  if(icon == null) child = Text(text);
  else child = Row(
      children: [
        Icon(icon),
        Text(text)
      ],
    );
    
  Widget elevatedButton = ElevatedButton(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)),
      textStyle: MaterialStateProperty.all(TextStyle(
        fontWeight: FontWeight.bold
      )),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0)
      )),
      backgroundColor: MaterialStateProperty.all(!isDisabled ? color.backgroundColor : color.disabledBackgroundColor),
      foregroundColor: MaterialStateProperty.all(!isDisabled ? color.textColor : color.disabledTextColor)
    ),
    onPressed: isDisabled ? null : onPressed,
    onLongPress: isDisabled ? null : onLongPressed,
    
    child: child,
  );
  
  return isFullWidth ? SizedBox(width: double.infinity, child: elevatedButton) : elevatedButton;
}

Widget buttonOutline(String text, {Function onPressed, Function onLongPressed, TypeStyle style = TypeStyle.primary, IconData icon, bool isDisabled = false, bool isFullWidth = false}) {
  var color = _getStyleButton(style);
  var child;

  Color textColor;
  if(style == TypeStyle.light) {
    textColor = isDisabled ? color.borderColorOutline : color.disabledTextColor;
  }
  else {
    textColor = isDisabled ? color.disabledBackgroundColor : color.backgroundColor;
  }
  // if(!isDisabled) textColor = style == TypeStyle.light ? color.disabledTextColor : color.disabledBackgroundColor;
  // else textColor = style == TypeStyle.light ? color.borderColorOutline : color.backgroundColor;
  if(icon == null) child = Text(text);
  else child = Row(
      children: [
        Icon(icon),
        Text(text)
      ],
    );
    var elevatedButton = ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontWeight: FontWeight.bold
        )),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0)
        )),
        side: MaterialStateProperty.all(BorderSide(color: style == TypeStyle.light ? color.borderColorOutline : color.backgroundColor)),
        foregroundColor: MaterialStateProperty.all(textColor),
        overlayColor: MaterialStateProperty.all(textColor.withOpacity(.2))
      ),
      onPressed: isDisabled ? null : onPressed,
      onLongPress: isDisabled ? null : onLongPressed,
      child: child
    );
  return isFullWidth ? SizedBox(width: double.infinity, child: elevatedButton) : elevatedButton;
}

_ButtonsHelper _getStyleButton(TypeStyle style) {
  _ButtonsHelper button;
  // style primary
  if(style == TypeStyle.primary) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.googleBlue,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.googleBlue2
    );
  // style secondary
  else if(style == TypeStyle.secondary) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.googleBlack2,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.googleBlack3
    );
  // style success
  else if(style == TypeStyle.success) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.googleGreen,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.googleGreen3
    );
  // style danger
  else if(style == TypeStyle.danger) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.googleRed,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.googleRed2
    );
  // style danger
  else if(style == TypeStyle.warning) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.googleYellow,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.googleYellow2
    );
  // style info
  else if(style == TypeStyle.info) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.germanBlue2,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.germanBlue
    );
  // style light
  else if(style == TypeStyle.light) button = new _ButtonsHelper(
      textColor: FlatColors.googleBlack,
      backgroundColor: FlatColors.v1White,
      disabledTextColor: FlatColors.v1White4,
      disabledBackgroundColor: FlatColors.googleWhite,
      borderColorOutline: FlatColors.googleWhite3
    );
  // style dark
  else if(style == TypeStyle.dark) button = new _ButtonsHelper(
      textColor: Colors.white,
      backgroundColor: FlatColors.googleBlack,
      disabledTextColor: FlatColors.googleWhite2,
      disabledBackgroundColor: FlatColors.googleBlack3
    );
  return button;
}

class _ButtonsHelper {
  final Color textColor;
  final Color backgroundColor;
  final Color disabledTextColor;
  final Color disabledBackgroundColor;

  final Color borderColorOutline;
  _ButtonsHelper({this.textColor, this.backgroundColor, this.disabledTextColor, this.disabledBackgroundColor, this.borderColorOutline});
}