// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class CreateConfirmPasswordFormField extends StatefulWidget {
  CreateConfirmPasswordFormField(
      {Key? key,
      required this.getPassword,
      required this.isConfiermPasswordHidden})
      : super(key: key);
  final Function getPassword;
  late bool isConfiermPasswordHidden;

  @override
  State<CreateConfirmPasswordFormField> createState() =>
      _CreateConfirmPasswordFormFieldState();
}

class _CreateConfirmPasswordFormFieldState
    extends State<CreateConfirmPasswordFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
            filled: true,
            labelText: LocaleKeys.confirm_password.tr(),
            labelStyle: TextStyle(fontSize: 20, color: AppColors.mainTextColor),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
            suffixIcon: widget.isConfiermPasswordHidden
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_off,
                      color: AppColors.mainTextColor,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.isConfiermPasswordHidden =
                            !widget.isConfiermPasswordHidden;
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
                        widget.isConfiermPasswordHidden =
                            !widget.isConfiermPasswordHidden;
                      });
                    },
                  )),
        obscureText: widget.isConfiermPasswordHidden,
        validator: (String? value) {
          if (value != widget.getPassword() || value!.isEmpty) {
            return LocaleKeys.confirm_password.tr();
          }
          return null;
        });
  }
}
