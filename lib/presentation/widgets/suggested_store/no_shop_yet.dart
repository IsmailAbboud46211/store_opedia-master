import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/custom_widgets/custom_text.dart';

Widget buildNoShopsYet(var size) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 5,
      ),
      Center(
        child: Column(
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
              text: LocaleKeys.no_stores_to_show.tr(),
              fontSize: 25,
            )
          ],
        ),
      ),
    ],
  );
}
