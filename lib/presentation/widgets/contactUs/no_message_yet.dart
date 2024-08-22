import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/custom_widgets/custom_text.dart';

Widget buildNoMessagesYet(var size) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 5,
      ),
      Center(
        child: Column(
          children: [
            Icon(
              Icons.info,
              color: AppColors.mainBlueColor,
              size: 75,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: CustomText(
                text: LocaleKeys.no_message_yet.tr(),
                fontSize: 25,
              ),
            )
          ],
        ),
      ),
    ],
  );
}
