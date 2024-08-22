import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../shared/colors.dart';
import '../../shared/custom_widgets/custom_text.dart';

Widget adminMessage(var size, var message) => Align(
      alignment: globalSharedPreference.getBool("isArabic") == false
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.all((size.width * 0.05)),
        decoration: BoxDecoration(
            color: AppColors.mainBlueColor,
            borderRadius: globalSharedPreference.getBool("isArabic") == false
                ? BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(
                      (size.width * 0.08),
                    ),
                    topEnd: Radius.circular(
                      (size.width * 0.08),
                    ),
                    topStart: Radius.circular(
                      (size.width * 0.08),
                    ),
                  )
                : BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(
                      (size.width * 0.08),
                    ),
                    topEnd: Radius.circular(
                      (size.width * 0.08),
                    ),
                    topStart: Radius.circular(
                      (size.width * 0.08),
                    ),
                  )),
        child: CustomText(
          text: message,
          textColor: AppColors.mainWhiteColor,
        ),
      ),
    );
