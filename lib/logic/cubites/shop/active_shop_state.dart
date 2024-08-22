part of 'active_shop_cubit.dart';

@immutable
abstract class ActiveShopState {}

class ActiveShopInitial extends ActiveShopState {}

class ActiveProgress extends ActiveShopState {}

class ActiveShopSucceed extends ActiveShopState {}

class ActiveShopFailed extends ActiveShopState {
  final String message;
  ActiveShopFailed({required this.message});
}
