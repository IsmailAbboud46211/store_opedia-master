part of 'deactivate_shop_cubit.dart';

@immutable
abstract class DeactivateShopState {}

class DeactivateShopInitial extends DeactivateShopState {}

class DeactivateShopProgress extends DeactivateShopState {}

class DeactivateShopSucceed extends DeactivateShopState {}

class DeactivateShopFailed extends DeactivateShopState {
  final String message;
  DeactivateShopFailed({required this.message});
}
