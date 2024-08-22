import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/logic/cubites/shop/shop_follwers_counter_cubit.dart';

import '../../../main.dart';

part 'following_state.dart';

class FollowingCubit extends Cubit<FollowingState> {
  late List<dynamic> updatedFollowedShops;
  FollowingCubit() : super(FollowingState(followedShops: [])) {
    state.followedShops = SharedPreferencesRepository.getFollowedStores();
  }
  void follow(Shop shop) {
    shop.isFollow = true;
    shop = updateShop(shop);
    globalSharedPreference.setBool('isFollowed', true);
    updatedFollowedShops = state.followedShops
      ..removeWhere((jsonshop) =>
          shop.ownerID == Shop.fromJson(jsonshop).ownerID &&
          shop.shopID == Shop.fromJson(jsonshop).shopID);
    updatedFollowedShops = state.followedShops..add(shop.toJson());

    saveFollowingState();
  }

  void unFollow(Shop shop) {
    shop.isFollow = false;
    shop = updateShop(shop);
    globalSharedPreference.setBool('isFollowed', false);

    updatedFollowedShops = state.followedShops
      ..removeWhere((jsonshop) =>
          shop.ownerID == Shop.fromJson(jsonshop).ownerID &&
          shop.shopID == Shop.fromJson(jsonshop).shopID);

    saveFollowingState();
  }

  Shop updateShop(Shop shop) {
    BlocListener<ShopFollwersCounterCubit, ShopFollwersCounterState>(
      listener: (context, state) {
        shop.followesNumber =
            context.read<ShopFollwersCounterCubit>().getShopFollwersCount(shop);
      },
    );
    return shop;
  }

  void saveFollowingState() {
    SharedPreferencesRepository.setFollowedStores(
        followedShopsList: updatedFollowedShops);
    emit(FollowingState(followedShops: updatedFollowedShops));
  }

  bool getShopFollowingState(Shop shop) {
    print(shop.toJson());

    return state.followedShops.isNotEmpty
        ? state.followedShops.firstWhere(
                (element) =>
                    shop.ownerID == Shop.fromJson(element).ownerID &&
                    shop.shopID == Shop.fromJson(element).shopID,
                orElse: () => null) !=
            null
        : false;
  }
}
