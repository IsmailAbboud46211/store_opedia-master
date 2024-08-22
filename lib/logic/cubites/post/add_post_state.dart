part of 'add_post_cubit.dart';

@immutable
abstract class AddPostState {}

class AddPostInitial extends AddPostState {}

class AddPostProgress extends AddPostState {}

class AddPostSucceed extends AddPostState {}

class AddPostFailed extends AddPostState {
  final String message;
  AddPostFailed({required this.message});
}
