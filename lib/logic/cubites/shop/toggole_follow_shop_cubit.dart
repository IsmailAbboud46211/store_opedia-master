// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/data/repositories/shop_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'toggole_follow_shop_state.dart';

class ToggoleFollowShopCubit extends Cubit<ToggoleFollowShopState> {
  ToggoleFollowShopCubit() : super(ToggoleFollowShopInitial());

  Future toggoleFolowShop(
      {required String shopID, required String ownerID}) async {
    emit(ProgressToggoleFollowShop());
    Map<String, dynamic>? response = await ShopRepository()
        .toggoleFollowShop(shopID: shopID, userID: ownerID);
    if (response == null || response["message"] == "Access Denied") {
      ScaffoldMessenger(
          child: Text(response == null
              ? LocaleKeys.follow_store_failed.tr()
              : LocaleKeys.access_denied.tr()));
      emit(FailedToggoleFollowShop(response == null
          ? LocaleKeys.follow_store_failed.tr()
          : response["message"]));
    } else {
      // const ScaffoldMessenger(child: Text('Rated Successfuly!'));
      emit(SucceedToggoleFollowShop(message: response["message"]));
    }
  }
}
