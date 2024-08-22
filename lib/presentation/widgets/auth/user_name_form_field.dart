import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class CreateUserNameFormField extends StatelessWidget {
  const CreateUserNameFormField({Key? key, required this.setUserName})
      : super(key: key);
  final Function setUserName;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: false,
        decoration: InputDecoration(
          filled: true,
          labelText: LocaleKeys.user_name.tr(),
          labelStyle: TextStyle(fontSize: 20, color: AppColors.mainTextColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
        ),
        validator: (String? value) {
          if (value!.isEmpty || value.length < 4 || value.length > 15) {
            return 'Please Enter a valid Name';
          }
          return null;
        },
        onSaved: (String? value) {
          setUserName(value!);
        });
  }
}
