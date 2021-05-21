
import 'package:flutter/material.dart';

import 'components_buttons_helper.dart';
import 'components_type_style.dart';

class Buttons extends StatelessWidget
{
  final String? text;
  final Function? onPressed;
  final Function? onLongPressed;
  final TypeStyle? style;
  final IconData? icon;
  final bool? enabled;
  final bool isRounded;
  // final bool isFullWidth;

  const Buttons( this.text, {
    Key? key,
    this.onPressed, 
    this.onLongPressed, 
    this.style = TypeStyle.primary, 
    this.icon, 
    this.enabled = true,
    this.isRounded = false
    // this.isFullWidth = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = ButtonsHelper.getStyleButton(style);
    var child;

    if(icon == null) child = Text(text!);
    else child = Row(
        children: [
          Icon(icon),
          Text(text!)
        ],
      );
    
    return ElevatedButton(
      key: key,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontWeight: FontWeight.bold
        )),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isRounded ? 100 : 0)
        )),
        backgroundColor: MaterialStateProperty.all(enabled! ? color!.backgroundColor : color!.disabledBackgroundColor),
        foregroundColor: MaterialStateProperty.all(enabled! ? color.textColor : color.disabledTextColor)
      ),
      onPressed: !enabled! ? null : onPressed as void Function()?,
      onLongPress: !enabled! ? null : onLongPressed as void Function()?,
      
      child: child,
    );
    
    // return isFullWidth ? SizedBox(width: double.infinity, child: elevatedButton) : elevatedButton;
    // return elevatedButton;
  }
  
}



