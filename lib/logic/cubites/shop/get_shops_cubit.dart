// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../data/repositories/shop_repository.dart';

part 'get_shops_state.dart';

class GetShopsCubit extends Cubit<GetShopsState> {
  GetShopsCubit() : super(GetShopsInitial());
  Shop? shop;

  void setShops({required var shops}) {
  }

  Future getShops() async {
    emit(GetShopsProgress());

    Map<String, dynamic>? response = await ShopRepository()
        .getShops(ownerID: globalSharedPreference.getString("ID")!);
    if (response == null || response["message"] != "Done") {
      emit(GetShopsFailed(
          message: response == null
              ? LocaleKeys.get_stores_failed.tr()
              : response["message"]));
    } else if (response["message"] == "Done") {
      setShops(shops: response["stores"]);

      emit(GetShopsSucceed());
    }
  }

  Future<Shop?> getShop(String shopID) async {
    emit(GetShopsProgress());

    Map<String, dynamic>? response =
        await ShopRepository().getShop(shopID: shopID);
    if (response == null) {
      emit(GetShopsFailed(
          message: response == null
              ? LocaleKeys.get_stores_failed.tr()
              : response["message"]));
    } else {
      shop = Shop.fromMap(response);
      emit(GetShopsSucceed());
    }
    return shop;
  }
}
