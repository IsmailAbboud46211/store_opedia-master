part of 'rate_shop_cubit.dart';

class RatePostState {
  double rate;
  RatePostState({required this.rate});
}

class RatePostInitial extends RatePostState {
  RatePostInitial({required double rate}) : super(rate: rate);
}
