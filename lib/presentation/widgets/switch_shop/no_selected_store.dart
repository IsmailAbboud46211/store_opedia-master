import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/pages/switch_store.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_button.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/colors.dart';
import '../../shared/custom_widgets/custom_text.dart';

Widget noSelectedShop(var size, BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        SizedBox(
          height: size.height / 3,
        ),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.mainBlueColor,
                size: 75,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              CustomText(
                text: LocaleKeys.you_didnt_select_any_shop_yet.tr(),
                bold: true,
                fontSize: 20,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.1),
                child: CustomButton(
                  text: LocaleKeys.select_store.tr(),
                  onPressed: () => context.push(const SwitchStore()),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
