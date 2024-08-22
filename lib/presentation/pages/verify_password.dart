import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/logic/cubites/user/verify_password_cubit.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/edit_profile/password_form_field.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../data/enums/message_type.dart';
import '../../logic/cubites/user/profile_cubit.dart';
import '../shared/custom_widgets/custom_toast.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({Key? key}) : super(key: key);

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

String? _password;
void setPassword(String password) {
  _password = password;
}

String? getPassword() => _password;

class _VerifyPasswordState extends State<VerifyPassword> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/verified.png'),
            SizedBox(
              height: size.height / 400,
            ),
            SizedBox(
              height: size.height * 0.009,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.009),
              child: EditPasswordFormField(
                  setPassword: setPassword,
                  isPasswordHidden: true,
                  password: ""),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        CustomToast.showMessage(
                            context: context,
                            size: size,
                            message: LocaleKeys
                                .you_have_to_write_the_password_first
                                .tr(),
                            messageType: MessageType.INFO);
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          backgroundColor: AppColors.mainWhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      child: Text(
                        LocaleKeys.cancle.tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )),
                ),
                (size.width * 0.08).px,
                Expanded(
                  child: BlocConsumer<VerifyPasswordCubit, VerifyPasswordState>(
                    listener: (context, state) {
                      if (state is VerifyPasswordFailed) {
                        CustomToast.showMessage(
                            context: context,
                            size: size,
                            message: state.message,
                            messageType: MessageType.REJECTED);
                      } else if (state is VerifyPasswordSucceed) {
                        CustomToast.showMessage(
                            context: context,
                            size: size,
                            message: LocaleKeys.verify_password_succeed.tr(),
                            messageType: MessageType.SUCCESS);
                        BlocProvider.of<ProfileCubit>(context).setVerifiy(true);
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is VerifyPasswordProgress) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                          onPressed: () {
                            getPassword() == null
                                ? CustomToast.showMessage(
                                    context: context,
                                    size: size,
                                    message: LocaleKeys
                                        .you_have_to_write_the_password_first
                                        .tr(),
                                    messageType: MessageType.INFO)
                                : context
                                    .read<VerifyPasswordCubit>()
                                    .verifyPassword(password: getPassword()!);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(
                            LocaleKeys.verify.tr(),
                            style: TextStyle(color: AppColors.mainWhiteColor),
                          ));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
