part of 'get_owner_shops_cubit.dart';

abstract class GetOwnerShopsState {}

class GetOwnerShopsInitial extends GetOwnerShopsState {}

class GetOwnerShopsProgress extends GetOwnerShopsState {}

class GetOwnerShopsSucceed extends GetOwnerShopsState {}

class GetOwnerShopsFiled extends GetOwnerShopsState {
  String message;
  GetOwnerShopsFiled({required this.message});
}
