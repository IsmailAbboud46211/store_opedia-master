part of 'edit_shop_cubit.dart';

@immutable
abstract class EditShopState {}

class EditShopInitial extends EditShopState {}

class EditShopProgress extends EditShopState {}

class EditShopSucceed extends EditShopState {}

class EditShopFailed extends EditShopState {
  final String message;
  EditShopFailed({required this.message});
}
