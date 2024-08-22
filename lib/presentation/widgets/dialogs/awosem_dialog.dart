// ignore_for_file: deprecated_member_use

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';

AwesomeDialog buildAwsomeDialog(
    BuildContext context, String title, String message, String action,
    {DialogType? type}) {
  return AwesomeDialog(
      btnOkColor: Colors.green,
      alignment: Alignment.center,
      context: context,
      title: title,
      body: Center(
          child: Text(message,
              style: const TextStyle(fontStyle: FontStyle.italic))),
      dialogType: type ?? DialogType.INFO,
      btnOkText: action,
      btnOkOnPress: () {},
      animType: AnimType.SCALE);
}
