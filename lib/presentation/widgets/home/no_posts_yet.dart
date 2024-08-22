import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';

import '../../shared/custom_widgets/custom_text.dart';

Widget buildNoPostsYet(var size, String text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: size.height / 12,
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.mainBlueColor,
              size: 75,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            CustomText(
              textAlign: TextAlign.center,
              text: text,
              fontSize: 20,
            ),
            SizedBox(
              height: size.height / 12,
            )
          ],
        ),
      ),
    ],
  );
}
