import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../logic/cubites/post/delete_post_cubit.dart';

void buildDeletePostAlert({
  required BuildContext context,
  required String ownerID,
  required String shopID,
  required String postID,
}) {
  AwesomeDialog(
      btnCancelColor: Colors.green,
      btnOkColor: Colors.red,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: Text(
          LocaleKeys.delete_post_alert.tr(),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        BlocProvider.of<DeletePostCubit>(context)
            .deletePost(postID: postID, ownerID: ownerID, shopID: shopID);
      }).show();
}
