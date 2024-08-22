part of 'shop_follwers_counter_cubit.dart';

class ShopFollwersCounterState {
  int shopFollowersCounter;
  Shop? shop;
  ShopFollwersCounterState(this.shopFollowersCounter, this.shop);
}

class ShopFollwersCounterInitial extends ShopFollwersCounterState {
  ShopFollwersCounterInitial(int shopFollowersCounter, Shop? shop)
      : super(shopFollowersCounter, shop);
}
