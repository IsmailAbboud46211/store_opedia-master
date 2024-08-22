part of 'toggole_follow_shop_cubit.dart';

abstract class ToggoleFollowShopState {}

class ToggoleFollowShopInitial extends ToggoleFollowShopState {}

class ProgressToggoleFollowShop extends ToggoleFollowShopState {}

class SucceedToggoleFollowShop extends ToggoleFollowShopState {
  String message;
  SucceedToggoleFollowShop({required this.message});
}

class FailedToggoleFollowShop extends ToggoleFollowShopState {
  String message;
  FailedToggoleFollowShop(this.message);
}
