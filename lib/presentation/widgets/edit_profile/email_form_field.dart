import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class EditEmailFormField extends StatelessWidget {
  const EditEmailFormField({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: email,
      enabled: false,
      decoration: InputDecoration(
        labelText: LocaleKeys.email.tr(),
        prefixIcon: Icon(
          Icons.mail,
          color: Theme.of(context).colorScheme.primary,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
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
