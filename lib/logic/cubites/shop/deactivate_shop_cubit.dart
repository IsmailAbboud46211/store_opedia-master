import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../../data/repositories/shop_repository.dart';

part 'deactivate_shop_state.dart';

class DeactivateShopCubit extends Cubit<DeactivateShopState> {
  DeactivateShopCubit() : super(DeactivateShopInitial());

  Future deactivateShop(
      {required String shopID, required String ownerID}) async {
    emit(DeactivateShopProgress());

    String? response = await ShopRepository()
        .toggleActivation(shopID: shopID, ownerID: ownerID);

    if (response == "Failed") {
      emit(DeactivateShopFailed(
          message: LocaleKeys.deactivate_store_failed.tr()));
    } else {
      emit(DeactivateShopSucceed());
    }
  }
}
