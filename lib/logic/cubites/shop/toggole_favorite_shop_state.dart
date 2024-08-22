part of 'toggole_favorite_shop_cubit.dart';

abstract class ToggoleFavoriteShopState {}

class ToggoleFavoriteShopInitial extends ToggoleFavoriteShopState {}

class ProgressToggoleFavoriteShop extends ToggoleFavoriteShopState {}

class SucceedToggoleFavoriteShop extends ToggoleFavoriteShopState {
  String message;
  SucceedToggoleFavoriteShop({required this.message});
}

class FailedToggoleFavoriteShop extends ToggoleFavoriteShopState {
  String message;
  FailedToggoleFavoriteShop(this.message);
}
