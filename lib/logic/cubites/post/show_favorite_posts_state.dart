part of 'show_favorite_posts_cubit.dart';

class ShowFavoritePostsState {
  final List<dynamic> favoritePosts;
  ShowFavoritePostsState({required this.favoritePosts});
}

class ShowFavoritePostsInitial extends ShowFavoritePostsState {
  ShowFavoritePostsInitial() : super(favoritePosts: []);
}

class ShowFavoritePostsFailed extends ShowFavoritePostsState {
  String message;
  ShowFavoritePostsFailed({required this.message}) : super(favoritePosts: []);
}

class ShowFavoritePostsSuccessed extends ShowFavoritePostsState {
  ShowFavoritePostsSuccessed() : super(favoritePosts: []);
}

class NoFavoritePosts extends ShowFavoritePostsState {
  NoFavoritePosts() : super(favoritePosts: []);
}

class ShowFavoritePostsProgress extends ShowFavoritePostsState {
  ShowFavoritePostsProgress() : super(favoritePosts: []);
}
