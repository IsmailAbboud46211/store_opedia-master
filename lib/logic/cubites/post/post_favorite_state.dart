part of 'post_favorite_cubit.dart';

class PostFavoriteState {
  List<dynamic> favoritePosts;
  PostFavoriteState({required this.favoritePosts});
}

class ProgressToggoleFavoritePost extends PostFavoriteState {
  @override
  // ignore: overridden_fields
  List<dynamic> favoritePosts;

  ProgressToggoleFavoritePost({required this.favoritePosts})
      : super(favoritePosts: favoritePosts);
}

class SucceedToggoleFavoritePost extends PostFavoriteState {
  @override
  // ignore: overridden_fields
  List<dynamic> favoritePosts;
  String message;

  SucceedToggoleFavoritePost(
      {required this.favoritePosts, required this.message})
      : super(favoritePosts: favoritePosts);
}

class FailedToggoleFavoritePost extends PostFavoriteState {
  @override
  // ignore: overridden_fields
  List<dynamic> favoritePosts;
  String message;

  FailedToggoleFavoritePost(
      {required this.favoritePosts, required this.message})
      : super(favoritePosts: favoritePosts);
}
