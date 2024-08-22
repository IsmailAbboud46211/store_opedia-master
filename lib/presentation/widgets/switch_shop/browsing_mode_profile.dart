import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/colors.dart';
import '../../shared/custom_widgets/custom_text.dart';

Widget browsingModeProfile(var size, var mode) {
  return Center(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        30.ph,
        Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: AppColors.secondaryFontColor,
                borderRadius: BorderRadius.circular(20)),
            width: size.width / 1.2,
            child: CustomText(
                fontSize: 20,
                textColor: Colors.white,
                text: mode == "browsing"
                    ? LocaleKeys.browsing_alert.tr()
                    : LocaleKeys.you_dont_have_store_now.tr())),
        Positioned(
          top: -30,
          right: -30,
          child: SvgPicture.asset(
            "assets/rejected-01.svg",
            height: 70,
          ),
        ),
      ],
    ),
  );
}
