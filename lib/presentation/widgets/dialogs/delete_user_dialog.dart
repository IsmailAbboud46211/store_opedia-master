// ignore_for_file: deprecated_member_use

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';
import 'package:shopesapp/logic/cubites/user/auth_state.dart';
import 'package:shopesapp/logic/cubites/user/delete_user_cubit.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/custom_widgets/custom_text.dart';

void showDeleteAlert(BuildContext context) {
  AwesomeDialog(
      btnOkColor: AppColors.mainRedColor,
      btnCancelColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is UserLoginedIn) {
              return CustomText(
                text: LocaleKeys.delete_user_account_alret.tr(),
                textAlign: TextAlign.center,
              );
            }
            return CustomText(
              text: LocaleKeys.delete_owner_account_alret.tr(),
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        BlocProvider.of<DeleteUserCubit>(context).deleteUser();
      }).show();
}
