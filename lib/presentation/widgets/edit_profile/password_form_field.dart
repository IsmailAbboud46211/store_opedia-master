import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../shared/utils.dart';

// ignore: must_be_immutable
class EditPasswordFormField extends StatefulWidget {
  EditPasswordFormField(
      {Key? key,
      required this.setPassword,
      required this.isPasswordHidden,
      required this.password})
      : super(key: key);
  final Function setPassword;
  late bool isPasswordHidden;
  final String password;

  @override
  State<EditPasswordFormField> createState() => _EditPasswordFormFieldState();
}

class _EditPasswordFormFieldState extends State<EditPasswordFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.password,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          labelText: LocaleKeys.password.tr(),
          labelStyle: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
          prefixIcon: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          // helperText: 'Password must be More Than 8',
          helperStyle: const TextStyle(fontSize: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          suffixIcon: widget.isPasswordHidden
              ? IconButton(
                  icon: Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.isPasswordHidden = !widget.isPasswordHidden;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.visibility,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.isPasswordHidden = !widget.isPasswordHidden;
                    });
                  },
                )),
      obscureText: widget.isPasswordHidden,
      validator: (String? value) {
        if (validPassword(value!)) {
          return 'Password  must be +8 Chars and include Uppare and Lower Chars ';
        }
        return null;
      },
      onChanged: (String? value) {
        widget.setPassword(value);
      },
      onSaved: (String? value) {
        widget.setPassword(value);
      },
    );
  }
}
