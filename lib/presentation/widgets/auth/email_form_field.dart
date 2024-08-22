import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class CreateEmailFormField extends StatelessWidget {
  const CreateEmailFormField({Key? key, required this.setEmail})
      : super(key: key);
  final Function setEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: LocaleKeys.email.tr(),
        labelStyle: TextStyle(
          color: AppColors.mainTextColor,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value == null ||
            value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return LocaleKeys.invalid_email.tr();
        }
        return null;
      },
      onSaved: (String? value) {
        setEmail(value);
      },
    );
  }
}
