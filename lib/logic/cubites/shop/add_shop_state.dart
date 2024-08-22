part of 'add_shop_cubit.dart';

@immutable
abstract class AddShopState {}

class AddShopInitial extends AddShopState {}

class AddShopProgress extends AddShopState {}

class AddShopSucceed extends AddShopState {}

class AddShopFailed extends AddShopState {
  final String message;
  AddShopFailed({required this.message});
}
