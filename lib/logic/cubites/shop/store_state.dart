// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'store_cubit.dart';

class StoreState {}

class ShopsInitial extends StoreState {}

class ShopsFetchedSuccessfully extends StoreState {}

class ErrorFetchingShops extends StoreState {
  String message;
  ErrorFetchingShops({required this.message});
}

class NoShopsYet extends StoreState {}

class FeatchingShopsProgress extends StoreState {}

class FeatchingShopsSucceed extends StoreState {}

class UpdateShopProgress extends StoreState {}

class UpdateShopSucceed extends StoreState {}

class UpdateShopFailed extends StoreState {
  final String message;
  UpdateShopFailed({required this.message});
}
