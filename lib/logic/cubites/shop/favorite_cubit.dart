import 'package:bloc/bloc.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';

import '../../../main.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  List<dynamic> updatedFavoriteShops = [];
  FavoriteCubit() : super(FavoriteState([])) {
    state.favoriteShops = SharedPreferencesRepository.getFavoriteStores();
    if (state.favoriteShops.isEmpty) {
      updatedFavoriteShops = state.favoriteShops;
    }
  }

  void addToFavorites(Shop shop) {
    if (!shop.isFavorit!) {
      shop.isFavorit = true;
      updatedFavoriteShops = state.favoriteShops..add(shop.toJson());
    }

    globalSharedPreference.setBool('isShopFavorite', true);

    SharedPreferencesRepository.setFavoriteStores(
        favoriteShopsList: updatedFavoriteShops);

    emit(FavoriteState(updatedFavoriteShops));
  }

  void removeFromFavorites(Shop shop) {
    shop.isFavorit = false;
    // globalSharedPreference.getString('')
    updatedFavoriteShops = state.favoriteShops
      ..removeWhere((jsonshop) =>
          shop.ownerID == Shop.fromJson(jsonshop).ownerID &&
          shop.shopID == Shop.fromJson(jsonshop).shopID);
    globalSharedPreference.setBool('isShopFavorite', false);

    SharedPreferencesRepository.setFavoriteStores(
        favoriteShopsList: updatedFavoriteShops);
    emit(FavoriteState(updatedFavoriteShops));
  }

  List<dynamic> getFavoriteShops() => state.favoriteShops;

  bool isShopFavorite(Shop shop) {
    print(shop.toJson());
    return state.favoriteShops.isNotEmpty
        ? state.favoriteShops.firstWhere(
                (element) =>
                    shop.ownerID == Shop.fromMap(element).ownerID &&
                    shop.shopID == Shop.fromMap(element).shopID,
                orElse: () => null) !=
            null
        : false;
  }
}
