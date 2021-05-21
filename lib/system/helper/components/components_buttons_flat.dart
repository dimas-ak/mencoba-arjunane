import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components_buttons_helper.dart';
import 'components_type_style.dart';

class ButtonsFlat extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final Function? onLongPressed;
  final TypeStyle? style;
  final IconData? icon;
  final bool enabled;
  // final bool isFullWidth;

  const ButtonsFlat( this.text, {
    Key? key,
    this.onPressed, 
    this.onLongPressed, 
    this.style = TypeStyle.primary, 
    this.icon, 
    this.enabled = true, 
    // this.isFullWidth = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = ButtonsHelper.getStyleButton(style);
    var child;

    Color? textColor;
    if(style == TypeStyle.light) {
      textColor = !enabled ? color!.borderColorOutline : color!.disabledTextColor;
    }
    else {
      textColor = !enabled ? color!.disabledBackgroundColor : color!.backgroundColor;
    }

    if(icon == null) child = Text(text!, style: TextStyle(color: textColor, fontWeight: FontWeight.bold));
    else child = Row(
        children: [
          Icon(icon),
          Text(text!, style: TextStyle(color: textColor, fontWeight: FontWeight.bold))
        ],
      );
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: textColor!.withOpacity(.2),
        onTap: !enabled ? null : onPressed as void Function()?,
        onLongPress: !enabled ? null : onLongPressed as void Function()?,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: child
        )
      ),
    );
    // Widget elevatedButton = ElevatedButton(
    //   key: key,
    //   style: ButtonStyle(
    //     padding: MaterialStateProperty.all(EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)),
    //     textStyle: MaterialStateProperty.all(TextStyle(
    //       fontWeight: FontWeight.bold
    //     )),
    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(0)
    //     )),
    //     backgroundColor: MaterialStateProperty.all(enabled ? color.backgroundColor : color.disabledBackgroundColor),
    //     foregroundColor: MaterialStateProperty.all(enabled ? color.textColor : color.disabledTextColor)
    //   ),
    //   onPressed: !enabled ? null : onPressed,
    //   onLongPress: !enabled ? null : onLongPressed,
      
    //   child: child,
    // );
    
    // return isFullWidth ? SizedBox(width: double.infinity, child: elevatedButton) : elevatedButton;
    // return elevatedButton;
  }

}