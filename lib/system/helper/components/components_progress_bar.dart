import 'package:flutter/cupertino.dart';
import '../flat_colors.dart';

class ProgressBar extends StatelessWidget {

  final Key? key;
  final double percentage;
  final String? textRight;
  final TextStyle? textRightStyle;
  final TextStyle? textTopStyle;
  final TextStyle? textBottomStyle;
  final String? textBottom;
  final String? textTop;
  final Color? colorBar;

  ProgressBar({
    this.key,
    required this.percentage,
    this.textRight,
    this.textRightStyle,
    this.textBottom,
    this.textBottomStyle,
    this.textTop,
    this.textTopStyle,
    this.colorBar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (ctx, orientation) {
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(textTop != null) Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(textTop!, style: textTopStyle)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  width:double.infinity,
                  height: 20,
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      var width = constraints.maxWidth;
                      double calc = percentage / 100 * width;
                      return Stack(
                        children: [
                          Positioned(
                            top:0,
                            left:0,
                            right:0,
                            bottom:0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorBar != null ? colorBar!.withOpacity(.2) : FlatColors.googleBlue.withOpacity(.2),
                                border: Border.all(
                                  color: colorBar != null ? colorBar!.withOpacity(.3) : FlatColors.googleBlue.withOpacity(.3),
                                  width: 1
                                )
                              ),
                          )),
                          Positioned(
                            top:0,
                            left:0,
                            bottom:0,
                            width: calc,
                            child: Container(
                            color: colorBar ?? FlatColors.googleBlue
                          ))
                        ],
                      );
                    },
                  ),
                )),
              if(textRight != null) Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(textRight!, style: textRightStyle),
              )
            ],
          ),
          if(textBottom != null) Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(textBottom!, style: textBottomStyle)),
        ],
      );
    });
  }

}