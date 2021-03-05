
import 'package:flutter/material.dart';

import '../flat_colors.dart';

/// HEADER  
/// 
/// H1 - H6
Widget heading(String text, {Color fontColor, TypeHeading typeHeading = TypeHeading.h1, TextAlign textAlign, FontStyle fontStyle}) {

  double fontSize;
  if(typeHeading == TypeHeading.h1) fontSize = 36;
  else if(typeHeading == TypeHeading.h2) fontSize = 28;
  else if(typeHeading == TypeHeading.h3) fontSize = 22;
  else if(typeHeading == TypeHeading.h4) fontSize = 20;
  else if(typeHeading == TypeHeading.h5) fontSize = 18;
  else if(typeHeading == TypeHeading.h6) fontSize = 16;

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


enum TypeHeading {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6
}