part of 'delete_user_cubit.dart';

@immutable
abstract class DeleteUserState {}

class DeleteUserInitial extends DeleteUserState {}

class DeleteUserProgress extends DeleteUserState {}

class DeleteUserSucceed extends DeleteUserState {}

class DeleteUserFailed extends DeleteUserState {
  final String message;
  DeleteUserFailed({required this.message});
}
