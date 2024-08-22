import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/repositories/auth_repository.dart';
part 'switch_shop_state.dart';

class SwitchShopCubit extends Cubit<SwitchShopState> {
  SwitchShopCubit() : super(SwitchShopInitial());

  Future swithShop({required var repoShop}) async {
    emit(SwithShopProgress());
    Shop shop = Shop.fromMap(repoShop);

    // ignore: unnecessary_null_comparison
    if (shop == null) {
      emit(SwithShopFiled());
    } else {
      AuthRepository().saveOwnerAndShop(shop: shop);
      emit(SwithShopSucceded());
    }
  }
}
