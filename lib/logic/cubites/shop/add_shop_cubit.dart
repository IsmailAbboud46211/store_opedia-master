import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../../data/repositories/shop_repository.dart';

part 'add_shop_state.dart';

class AddShopCubit extends Cubit<AddShopState> {
  AddShopCubit() : super(AddShopInitial());

  Future addShop({
    required String? facebookAccount,
    required String? instagramAccount,
    required String shopName,
    required String shopDescription,
    required String? shopProfileImage,
    required String? shopCoverImage,
    required String shopCategory,
    required String location,
    required double latitude,
    required double longitude,
    required String closing,
    required String opening,
    required String shopPhoneNumber,
    required String storeProfileImageType,
    required String storeCoverImageType,
  }) async {
    emit(AddShopProgress());
    String response = await ShopRepository().addShop(
      storeProfileImageType: storeProfileImageType,
      storeCoverImageType: storeCoverImageType,
      facebookAccount: facebookAccount,
      instagramAccount: instagramAccount,
      ownerID: globalSharedPreference.getString("ID")!,
      shopName: shopName,
      shopDescription: shopDescription,
      shopProfileImage: shopProfileImage,
      shopCoverImage: shopCoverImage,
      shopCategory: shopCategory,
      location: location,
      closing: closing,
      opening: opening,
      shopPhoneNumber: shopPhoneNumber,
      latitude: latitude,
      longitude: longitude,
    );

    if (response == "Failed") {
      emit(AddShopFailed(message: LocaleKeys.add_stroe_failed.tr()));
    } else {
      emit(AddShopSucceed());
    }
  }
}
