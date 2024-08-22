import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';

class CustomIconTextRow extends StatelessWidget {
  const CustomIconTextRow(
      {Key? key,
      this.icon,
      required this.text,
      this.iconColor,
      this.textColor,
      this.fontSize,
      this.svgIcon})
      : super(key: key);
  final String? svgIcon;
  final IconData? icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        svgIcon != null
            ? SvgPicture.asset(
                'assets/$svgIcon.svg',
                width: 25,
                height: 25,
              )
            : Icon(
                icon,
                color: iconColor ?? Colors.grey[600],
              ),
        20.px,
        CustomText(
          text: text,
          fontSize: fontSize ?? 15,
          textColor: textColor ?? AppColors.mainBlackColor,
        ),
      ],
    );
  }
}
