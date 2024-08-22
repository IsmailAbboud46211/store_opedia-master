import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/pages/login_page.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/custom_widgets/custom_text.dart';

void showBrowsingDialogAlert(BuildContext context) {
  AwesomeDialog(
      btnOkColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: CustomText(
          text: LocaleKeys.browsing_alert.tr(),
          textAlign: TextAlign.center,
        ),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.ok.tr(),
      btnOkOnPress: () {
        context.pushRepalceme(const LoginPage());
      }).show();
}
