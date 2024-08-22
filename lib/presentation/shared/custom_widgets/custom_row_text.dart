import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';

class CustomRowText extends StatelessWidget {
  const CustomRowText(
      {Key? key, required this.firstText, required this.linkText, this.onTap})
      : super(key: key);

  final String firstText, linkText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(text: firstText),
        InkWell(
          onTap: onTap,
          child: CustomText(
            text: linkText,
            textColor: AppColors.mainOrangeColor,
            bold: true,
          ),
        ),
      ],
    );
  }
}
