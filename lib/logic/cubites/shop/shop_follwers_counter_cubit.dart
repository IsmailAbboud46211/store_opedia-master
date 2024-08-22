// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/main.dart';

part 'shop_follwers_counter_state.dart';

class ShopFollwersCounterCubit extends Cubit<ShopFollwersCounterState> {
  ShopFollwersCounterCubit() : super(ShopFollwersCounterInitial(0, null));

  void incrementFollowers(Shop shop) {
    shop.followesNumber = shop.followesNumber! + 1;

    SharedPreferencesRepository.setStoreFollowers(
      shop.followesNumber!,
      shop,
    );
    globalSharedPreference.setInt('followesNumber', shop.followesNumber!);

    emit(ShopFollwersCounterState(shop.followesNumber!, shop));
  }

  void decrementFollowers(Shop shop) {
    shop.followesNumber! > 0
        ? shop.followesNumber = shop.followesNumber! - 1
        : shop.followesNumber = 0;

    SharedPreferencesRepository.setStoreFollowers(
      shop.followesNumber!,
      shop,
    );
    globalSharedPreference.setInt('followesNumber', shop.followesNumber!);

    emit(ShopFollwersCounterState(shop.followesNumber!, shop));
  }

  int getShopFollwersCount(Shop shop) {
    return SharedPreferencesRepository.getStoreFollowers(shop);
  }
}
