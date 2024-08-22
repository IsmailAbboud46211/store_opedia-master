part of 'delete_post_cubit.dart';

@immutable
abstract class DeletePostState {}

class DeletePostInitial extends DeletePostState {}

class DeletePostProgress extends DeletePostState {}

class DeletePostSucceed extends DeletePostState {}

class DeletePostFailed extends DeletePostState {
  final String message;
  DeletePostFailed({required this.message});
}
