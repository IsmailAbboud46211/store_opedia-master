// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';

import '../../../translation/locale_keys.g.dart';
import '../../shared/custom_widgets/custom_text.dart';

Widget buildNoInternet(var size) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 5,
      ),
      Center(
        child: Column(
          children: [
            Icon(
              Icons.wifi_off,
              color: AppColors.mainBlueColor,
              size: 75,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            CustomText(
              text: LocaleKeys.no_internet.tr(),
              fontSize: 25,
            )
          ],
        ),
      ),
    ],
  );
}
