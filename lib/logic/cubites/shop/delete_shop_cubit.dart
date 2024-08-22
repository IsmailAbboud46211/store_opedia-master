// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../../data/repositories/shop_repository.dart';

part 'delete_shop_state.dart';

class DeleteShopCubit extends Cubit<DeleteShopState> {
  DeleteShopCubit() : super(DeleteShopInitial());

  Future deleteShop({required String shopID}) async {
    emit(DeleteShopProgress());
    String? ownerID = globalSharedPreference.getString("ID");

    String response =
        await ShopRepository().deleteShop(shopID: shopID, ownerID: ownerID!);

    if (response == "Failed") {
      emit(DeleteShopFailed(message: LocaleKeys.delete_store_failed.tr()));
    } else {
      emit(DeleteShopSucceed());
    }
  }
}
