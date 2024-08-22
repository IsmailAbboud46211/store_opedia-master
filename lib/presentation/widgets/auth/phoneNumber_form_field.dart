import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/utils.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class CreatePhoneNumberFormField extends StatelessWidget {
  final Function setPhoneNumber;

  const CreatePhoneNumberFormField({Key? key, required this.setPhoneNumber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 10,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: true,
          labelText: LocaleKeys.phone_number.tr(),
          labelStyle: TextStyle(fontSize: 20, color: AppColors.mainTextColor),
          prefixIcon: Icon(
            Icons.phone,
            color: AppColors.mainTextColor,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
        ),
        validator: (String? value) {
          if (value!.isEmpty || !isMobileNumber(value)) {
            return 'Please Enter a valid phone Number';
          }

          return null;
        },
        onSaved: (String? value) {
          setPhoneNumber(value);
        });
  }
}
