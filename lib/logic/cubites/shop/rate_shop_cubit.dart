import 'package:bloc/bloc.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/data/repositories/shop_repository.dart';

import '../../../data/enums/message_type.dart';
import '../../../presentation/shared/custom_widgets/custom_toast.dart';

part 'rate_shop_state.dart';

class RateShopCubit extends Cubit<RateShopState> {
  RateShopCubit() : super(RateShopInitial(rate: 0));

  double? ratevalue = 0.0;

  Future<void> setShopRating({
    required double newRate,
    required userID,
    required shopId,
    required context,
    required size,
  }) async {
    Map<String, dynamic>? response = await ShopRepository()
        .sendShopRating(userID: userID, shopID: shopId, rateValue: newRate);
    if (response == null) {
      CustomToast.showMessage(
          context: context,
          size: size,
          message: "Some thing Wrong",
          messageType: MessageType.REJECTED);

      emit(RateShopFailed(rate: ratevalue!));
    } else if (response["message"] == "Done") {
      ratevalue = double.parse(response["ratingNumber"].toString());
      CustomToast.showMessage(
          context: context,
          size: size,
          message: "Success",
          messageType: MessageType.SUCCESS);
      SharedPreferencesRepository.setStoreRate(
          ownerId: userID, shopId: shopId, rate: newRate);
      emit(RateShopSucceded(rate: ratevalue!));
    }
  }

  double getShopRating({required ownerId, required shopId}) {
    return SharedPreferencesRepository.getStoreRate(
        ownerId: ownerId, shopId: shopId);
  }
}
