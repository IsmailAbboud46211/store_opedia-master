import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class EditPhoneNumberFormField extends StatelessWidget {
  final Function setPhoneNumber;
  final String phoneNmber;

  const EditPhoneNumberFormField(
      {Key? key, required this.setPhoneNumber, required this.phoneNmber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 10,
        initialValue: phoneNmber,
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
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        validator: (String? value) {
          if (value!.isEmpty ||
              value.length < 10 ||
              value.substring(0, 2) != '09') {
            return 'Please Enter a valid phone Number';
          }
          return null;
        },
        onChanged: (String? value) {
          setPhoneNumber(value);
        },
        onSaved: (String? value) {
          setPhoneNumber(value);
        });
  }
}
