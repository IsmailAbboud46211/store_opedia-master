part of 'delete_shop_cubit.dart';

@immutable
abstract class DeleteShopState {}

class DeleteShopInitial extends DeleteShopState {}

class DeleteShopProgress extends DeleteShopState {}

class DeleteShopSucceed extends DeleteShopState {}

class DeleteShopFailed extends DeleteShopState {
  final String message;
  DeleteShopFailed({required this.message});
}
