// ignore_for_file: unused_import, depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/data/models/owner.dart';
import 'package:shopesapp/data/repositories/shop_repository.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
part 'get_owner_shops_state.dart';

class GetOwnerShopsCubit extends Cubit<GetOwnerShopsState> {
  GetOwnerShopsCubit() : super(GetOwnerShopsInitial());

  List<dynamic> ownerShops = [];

  void setOwnerShop({required List<dynamic> shops}) {
    ownerShops = shops;
  }

  Future getOwnerShopsRequest(
      {required String? ownerID, required String message}) async {
    emit(GetOwnerShopsProgress());

    Map<String, dynamic>? response = await ShopRepository()
        .getOwnerShpos(ownerID: ownerID, message: message);
    if (response == null || response["message"] != "Succeed") {
      emit(GetOwnerShopsFiled(
          message: response == null
              ? LocaleKeys.get_stores_failed.tr()
              : response["message"]));
    } else if (response["message"] == "Succeed") {
      setOwnerShop(shops: response["shops"]);

      emit(GetOwnerShopsSucceed());
    }
  }
}
