part of 'get_shops_cubit.dart';

@immutable
abstract class GetShopsState {}

class GetShopsInitial extends GetShopsState {}

class GetShopsProgress extends GetShopsState {}

class GetShopsSucceed extends GetShopsState {}

class GetShopsFailed extends GetShopsState {
  final String message;
  GetShopsFailed({required this.message});
}
