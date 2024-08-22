// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class ProfilePhoneNumberFormField extends StatelessWidget {
  final String phoneNmber;

  const ProfilePhoneNumberFormField({Key? key, required this.phoneNmber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 10,
      initialValue: phoneNmber,
      enabled: false,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: LocaleKeys.phone_number.tr(),
        labelStyle: TextStyle(
            fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
        prefixIcon: Icon(
          Icons.phone,
          color: Theme.of(context).colorScheme.primary,
        ),
        helperStyle: const TextStyle(fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
