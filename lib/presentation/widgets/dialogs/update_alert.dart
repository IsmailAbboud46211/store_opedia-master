import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../logic/cubites/user/update_user_cubit.dart';
import '../../../main.dart';

void showUpdateAlert({
  required BuildContext context,
  required String userName,
  required String password,
  required String phoneNumber,
}) {
  AwesomeDialog(
      btnOkColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: Text(
          LocaleKeys.update_profile_alert.tr(),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        BlocProvider.of<UpdateUserCubit>(context).updateUser(
          id: globalSharedPreference.getString("ID")!,
          name: userName,
          password: password,
          phoneNumber: phoneNumber,
        );
      }).show();
}
