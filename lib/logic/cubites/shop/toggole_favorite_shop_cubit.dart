// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../data/repositories/shop_repository.dart';

part 'toggole_favorite_shop_state.dart';

class ToggoleFavoriteShopCubit extends Cubit<ToggoleFavoriteShopState> {
  ToggoleFavoriteShopCubit() : super(ToggoleFavoriteShopInitial());

  Future toggoleFavoriteShop(
      {required String shopID, required String ownerID}) async {
    emit(ProgressToggoleFavoriteShop());
    Map<String, dynamic>? response = await ShopRepository()
        .toggoleFavoriteShop(shopID: shopID, ownerID: ownerID);
    if (response == null || response["message"] == "Access Denied") {
      emit(FailedToggoleFavoriteShop(response == null
          ? LocaleKeys.fav_store_failed.tr()
          : response["message"]));
    } else {
      emit(SucceedToggoleFavoriteShop(message: response["message"]));
    }
  }
}
