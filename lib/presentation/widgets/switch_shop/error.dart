import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/custom_widgets/custom_text.dart';

Widget buildError(var size) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 5,
      ),
      Center(
        child: Column(
          children: [
            const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 75,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            CustomText(
              text: LocaleKeys.error.tr(),
              fontSize: 25,
            )
          ],
        ),
      ),
    ],
  );
}
