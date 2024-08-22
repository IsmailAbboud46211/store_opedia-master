// ignore_for_file: non_constant_identifier_names

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopesapp/data/enums/message_type.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';

import '../colors.dart';

class CustomToast {
  static showMessage(
      {required Size size,
      required String message,
      MessageType? messageType = MessageType.INFO,
      BuildContext? context}) {
    String imageName = 'info';
    Color ShadowColor = AppColors.mainBlueColor;

    switch (messageType) {
      case MessageType.REJECTED:
        imageName = 'rejected-01';
        ShadowColor = AppColors.mainRedColor;
        break;
      case MessageType.SUCCESS:
        imageName = 'approved1-01';
        ShadowColor = Colors.greenAccent;
        break;
      case MessageType.INFO:
        imageName = 'info';
        ShadowColor = AppColors.mainBlueColor;
        break;
      case MessageType.WARNING:
        imageName = 'warning';
        ShadowColor = Colors.amber;
        break;

      case null:
        break;
    }
    BotToast.showCustomText(
      toastBuilder: (value) {
        const Duration(seconds: 15);
        return Container(
            width: size.width * 0.75,
            decoration: BoxDecoration(
                color: context != null
                    ? Theme.of(context).colorScheme.onSurface
                    : AppColors.mainWhiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ShadowColor.withOpacity(0.5),
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.width * 0.06,
                ),
                SvgPicture.asset(
                  'assets/$imageName.svg',
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                ),
                SizedBox(
                  height: size.width * 0.06,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                      textAlign: TextAlign.center,
                      text: message,
                      textColor: AppColors.primaryFontColor),
                ),
                SizedBox(
                  height: size.width * 0.06,
                ),
              ],
            ));
      },
    );
  }
}
