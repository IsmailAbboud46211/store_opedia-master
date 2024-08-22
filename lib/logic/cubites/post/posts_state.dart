part of 'posts_cubit.dart';

abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsFetchedSuccessfully extends PostsState {}

class ErrorFetchingPosts extends PostsState {
  String message;
  ErrorFetchingPosts({required this.message});
}

class NoPostsYet extends PostsState {}

class FeatchingPostsProgress extends PostsState {}

class OldestPostsFiltered extends PostsState {}
