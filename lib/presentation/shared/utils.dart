import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopesapp/data/enums/file_type.dart';
import 'package:shopesapp/data/enums/message_type.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_toast.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

bool isEmail(String value) {
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return regExp.hasMatch(value);
}

bool validPassword(String password) {
  RegExp passExp =
      RegExp(r'^(?=.*[^a-zA-Z\d\s])(?=.*[a-zA-Z])[@$!%*?&a-zA-Z\d]{8,}$');
  return passExp.hasMatch(password);
}

bool isName(String name) {
  RegExp nameExp = RegExp(r'^[a-zA-Z\d\s]{2,15}$');
  return nameExp.hasMatch(name);
}

bool isMobileNumber(String num) {
  RegExp numExp = RegExp(r'^((\+|00)?(963)|0)?9[0-9]{8}$');
  return numExp.hasMatch(num);
}

class FileTypeModel {
  FileType type;
  String path;

  FileTypeModel(this.path, this.type);
}

Future cLaunchUrl(Uri url) async {
  if (await canLaunchUrl(url)) {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      CustomToast.showMessage(
          message: LocaleKeys.cant_lunch_url.tr(),
          messageType: MessageType.REJECTED,
          size: const Size(400, 100));
    }
  } else {
    CustomToast.showMessage(
        message: LocaleKeys.app_not_installed.tr(),
        messageType: MessageType.REJECTED,
        size: const Size(400, 100));
  }
}

void customLoader(Size size) =>
    BotToast.showCustomLoading(toastBuilder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.mainBlackColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
        width: size.width / 4,
        height: size.width / 4,
        child: SpinKitCircle(
          color: AppColors.mainOrangeColor,
          size: size.width / 8,
        ),
      );
    });
