// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../../data/repositories/shop_repository.dart';

part 'active_shop_state.dart';

class ActiveShopCubit extends Cubit<ActiveShopState> {
  ActiveShopCubit() : super(ActiveShopInitial());

  Future activeShop({required String shopID, required String ownerID}) async {
    emit(ActiveProgress());

    String? response = await ShopRepository()
        .toggleActivation(shopID: shopID, ownerID: ownerID);

    if (response == "Failed") {
      emit(ActiveShopFailed(message: LocaleKeys.activate_stroe_failed.tr()));
    } else {
      emit(ActiveShopSucceed());
    }
  }
}
