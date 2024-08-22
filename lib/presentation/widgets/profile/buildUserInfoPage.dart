// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/profile/password_form_field.dart';
import 'package:shopesapp/presentation/widgets/profile/phoneNumber_form_field.dart';

import '../../../translation/locale_keys.g.dart';
import '../../pages/verify_password.dart';
import '../../shared/colors.dart';
import '../../shared/custom_widgets/custom_text.dart';
import 'email_form_field.dart';

// ignore: unused_element
Widget buildUserInfoPage({
  required BuildContext context,
  required Size size,
  required String email,
  required String oldPhoneNumber,
  required String oldName,
}) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Center(
              child: CustomText(
            text: oldName,
            fontSize: 25,
          )),
          (size.height * 0.05).ph,
          ProfileEmailFormField(
            email: email,
          ),
          (size.height * 0.005).ph,
          const ProfilePasswordFormField(password: "123456789"),
          (size.height * 0.005).ph,
          ProfilePhoneNumberFormField(phoneNmber: oldPhoneNumber),
          (size.height * 0.1).ph,
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
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
                      LocaleKeys.back.tr(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )),
              ),
              (size.width * 0.08).px,
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      context.push(const VerifyPassword());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      LocaleKeys.edit.tr(),
                      style: TextStyle(color: AppColors.mainWhiteColor),
                    )),
              ),
            ],
          )
        ],
      ));
}
