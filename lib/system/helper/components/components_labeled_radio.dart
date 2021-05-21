import 'package:flutter/material.dart';

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.fillColor
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final String? groupValue;
  final String value;
  final MaterialStateProperty<Color?>? fillColor;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          if(onChanged != null)onChanged!(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 24,
              height: 34,
              child: Radio<String>(
                fillColor: fillColor,
                groupValue: groupValue,
                value: value,
                onChanged: onChanged == null ? null : (String? newValue) {
                  onChanged!(newValue);
                },
              )
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}