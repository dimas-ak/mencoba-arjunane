
import 'package:flutter/material.dart';

import '../flat_colors.dart';

class Header extends StatelessWidget
{
  final String text;
  final Color? fontColor;
  final TypeHeader? typeHeader;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;

  Header(this.text, {
    Key? key,
    this.fontColor,
    this.typeHeader,
    this.textAlign,
    this.fontStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? fontSize;
    if(typeHeader == TypeHeader.h1) fontSize = 36;
    else if(typeHeader == TypeHeader.h2) fontSize = 28;
    else if(typeHeader == TypeHeader.h3) fontSize = 22;
    else if(typeHeader == TypeHeader.h4) fontSize = 20;
    else if(typeHeader == TypeHeader.h5) fontSize = 18;
    else if(typeHeader == TypeHeader.h6) fontSize = 16;

    return Text(text, 
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor == null ? FlatColors.googleBlack : fontColor,
        fontWeight: FontWeight.bold,
        fontStyle: fontStyle
      )
    );
  }
  
}
/// HEADER  
/// 
/// H1 - H6
Widget heading(String text, {Color? fontColor, TypeHeader typeHeader = TypeHeader.h1, TextAlign? textAlign, FontStyle? fontStyle}) {

  double? fontSize;
  if(typeHeader == TypeHeader.h1) fontSize = 36;
  else if(typeHeader == TypeHeader.h2) fontSize = 28;
  else if(typeHeader == TypeHeader.h3) fontSize = 22;
  else if(typeHeader == TypeHeader.h4) fontSize = 20;
  else if(typeHeader == TypeHeader.h5) fontSize = 18;
  else if(typeHeader == TypeHeader.h6) fontSize = 16;

  return Text(text, 
    textAlign: textAlign,
    style: TextStyle(
      fontSize: fontSize,
      color: fontColor == null ? FlatColors.googleBlack : fontColor,
      fontWeight: FontWeight.bold,
      fontStyle: fontStyle
    )
  );
}


enum TypeHeader {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6
}