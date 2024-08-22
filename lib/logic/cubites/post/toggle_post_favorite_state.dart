part of 'toggle_post_favorite_cubit.dart';

abstract class TogglePostFavoriteState {}

class ToggoleFavoritePostInitial extends TogglePostFavoriteState {}

class ProgressToggoleFavoritePost extends TogglePostFavoriteState {}

class SucceedToggoleFavoritePost extends TogglePostFavoriteState {
  String message;
  SucceedToggoleFavoritePost({required this.message});
}

class FailedToggoleFavoritePost extends TogglePostFavoriteState {
  String message;
  FailedToggoleFavoritePost(this.message);
}
