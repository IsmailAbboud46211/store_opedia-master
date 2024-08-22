part of 'rate_shop_cubit.dart';

class RateShopState {
  double rate;
  RateShopState({required this.rate});
}

class RateShopInitial extends RateShopState {
  RateShopInitial({required double rate}) : super(rate: rate);
}

class RateShopFailed extends RateShopState {
  RateShopFailed({required double rate}) : super(rate: rate);
}

class RateShopSucceded extends RateShopState {
  RateShopSucceded({required double rate}) : super(rate: rate);
}
