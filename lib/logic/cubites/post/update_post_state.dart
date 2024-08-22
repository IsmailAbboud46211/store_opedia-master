part of 'update_post_cubit.dart';

@immutable
abstract class UpdatePostState {}

class UpdatePostInitial extends UpdatePostState {}

class UpdatePostProgress extends UpdatePostState {}

class UpdatePostSucceed extends UpdatePostState {}

class UpdatePostFailed extends UpdatePostState {
  final String message;
  UpdatePostFailed({required this.message});
}
