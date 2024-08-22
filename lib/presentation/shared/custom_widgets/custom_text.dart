import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final Color? textColor;
  final double? fontSize;
  final TextAlign? textAlign;
  final bool? underline;
  final bool? bold;
  final String text;

  const CustomText(
      {Key? key,
      this.textColor,
      this.fontSize,
      this.bold,
      required this.text,
      this.textAlign,
      this.underline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          overflow: TextOverflow.fade,
          fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize ?? 16,
          decoration: underline! ? TextDecoration.underline : null,
          color: textColor ?? Theme.of(context).primaryColorDark,
        ));
  }
}
