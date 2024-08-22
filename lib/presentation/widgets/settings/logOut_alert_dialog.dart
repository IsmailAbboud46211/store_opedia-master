import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/pages/login_page.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../logic/cubites/user/auth_cubit.dart';
import '../../../logic/cubites/cubit/settings/Themes/themes_cubit.dart';

void showLogOutAlertDialog(BuildContext context) {
  AwesomeDialog(
      btnOkColor: AppColors.mainRedColor,
      btnCancelColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: Text(
          LocaleKeys.logOut_Warning.tr(),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () async {
        BlocProvider.of<AuthCubit>(context).logOut();
        context.read<ThemesCubit>().changeTheme(0);
        context.pushRepalceme(const LoginPage());
        await context.setLocale(const Locale('en'));
        globalSharedPreference.setBool("isArabic", false);
      }).show();
}
