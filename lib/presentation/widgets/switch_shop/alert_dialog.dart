import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../logic/cubites/shop/active_shop_cubit.dart';
import '../../../logic/cubites/shop/deactivate_shop_cubit.dart';
import '../../../logic/cubites/shop/delete_shop_cubit.dart';
import '../../../logic/cubites/shop/switch_shop_cubit.dart';
import '../../shared/custom_widgets/custom_text.dart';

void showAlertDialog(BuildContext context, var shop) {
  AwesomeDialog(
      btnOkColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.infoReverse,
      body: Center(
          child: CustomText(
        text: LocaleKeys.work_on_the_app_with_this_stroe.tr(),
        fontSize: 16,
      )),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        context.read<SwitchShopCubit>().swithShop(repoShop: shop);
      }).show();
}

void deleteShopAlert(BuildContext context, var shopID, bool isLastShop) {
  AwesomeDialog(
      btnOkColor: AppColors.mainRedColor,
      btnCancelColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.infoReverse,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: isLastShop == false
                ? CustomText(text: LocaleKeys.single_store_delete.tr())
                : CustomText(text: LocaleKeys.last_stroe_delete.tr())),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        context.read<DeleteShopCubit>().deleteShop(shopID: shopID);
      }).show();
}

void deactivatedShopAlert(BuildContext context, var shopID) {
  AwesomeDialog(
      btnOkColor: AppColors.mainRedColor,
      btnCancelColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.infoReverse,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: CustomText(text: LocaleKeys.deactivate_stroe_alert.tr())),
      ),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        context.read<DeactivateShopCubit>().deactivateShop(
              shopID: shopID,
              ownerID: globalSharedPreference.getString("ID")!,
            );
      }).show();
}

void activeShopAlert(BuildContext context, var shopID) {
  AwesomeDialog(
      btnOkColor: Colors.green,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.infoReverse,
      body: Center(
          child: CustomText(
        text: LocaleKeys.active_store_alert.tr(),
        fontSize: 16,
      )),
      btnCancelOnPress: () {},
      btnCancelText: LocaleKeys.cancle.tr(),
      btnOkText: LocaleKeys.countinue.tr(),
      btnOkOnPress: () {
        context.read<ActiveShopCubit>().activeShop(
              shopID: shopID,
              ownerID: globalSharedPreference.getString("ID")!,
            );
      }).show();
}

void cantDeactivatedShop(BuildContext context) {
  AwesomeDialog(
          btnOkColor: Colors.green,
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.info,
          body: Center(
              child: CustomText(
            text: LocaleKeys.last_store_deactiveate.tr(),
            fontSize: 16,
          )),
          btnOkText: LocaleKeys.ok.tr(),
          btnOkOnPress: () {})
      .show();
}
