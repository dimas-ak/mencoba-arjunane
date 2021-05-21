
import 'package:flutter/material.dart';

import '../flat_colors.dart';
import 'components_type_style.dart';

class ButtonsHelper {
  final Color? textColor;
  final Color? backgroundColor;
  final Color? disabledTextColor;
  final Color? disabledBackgroundColor;

  final Color? borderColorOutline;
  ButtonsHelper({this.textColor, this.backgroundColor, this.disabledTextColor, this.disabledBackgroundColor, this.borderColorOutline});

  static ButtonsHelper? getStyleButton(TypeStyle? style) {
    ButtonsHelper? button;
    // style primary
    if(style == TypeStyle.primary) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.googleBlue,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.googleBlue2
      );
    // style secondary
    else if(style == TypeStyle.secondary) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.googleBlack2,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.googleBlack3
      );
    // style success
    else if(style == TypeStyle.success) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.googleGreen,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.googleGreen3
      );
    // style danger
    else if(style == TypeStyle.danger) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.googleRed,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.googleRed2
      );
    // style danger
    else if(style == TypeStyle.warning) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.googleYellow,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.googleYellow2
      );
    // style info
    else if(style == TypeStyle.info) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.germanBlue2,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.germanBlue
      );
    // style light
    else if(style == TypeStyle.light) button = new ButtonsHelper(
        textColor: FlatColors.googleBlack,
        backgroundColor: FlatColors.v1White,
        disabledTextColor: FlatColors.v1White4,
        disabledBackgroundColor: FlatColors.googleWhite,
        borderColorOutline: FlatColors.googleWhite3
      );
    // style dark
    else if(style == TypeStyle.dark) button = new ButtonsHelper(
        textColor: Colors.white,
        backgroundColor: FlatColors.googleBlack,
        disabledTextColor: FlatColors.googleWhite2,
        disabledBackgroundColor: FlatColors.googleBlack3
      );
    return button;
  }

}