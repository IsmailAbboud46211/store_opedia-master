part of 'update_user_cubit.dart';

@immutable
abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserProgress extends UpdateUserState {}

class UpdateUserSucceed extends UpdateUserState {}

class UpdateUserFailed extends UpdateUserState {
  final String message;
  UpdateUserFailed({required this.message});
}
