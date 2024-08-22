import 'package:bloc/bloc.dart';
import 'package:shopesapp/data/models/post.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/main.dart';
part 'post_favorite_state.dart';

class PostFavoriteCubit extends Cubit<PostFavoriteState> {
  late List<dynamic> updatedFavoritePosts;
  PostFavoriteCubit() : super(PostFavoriteState(favoritePosts: [])) {
    state.favoritePosts = SharedPreferencesRepository.getFavoritePosts();
    updatedFavoritePosts = state.favoritePosts;
  }

  void addToFavorites(Post post) {
    if (!post.isFavorit!) {
      post.isFavorit = true;
      updatedFavoritePosts = state.favoritePosts..add(post.toJson());
    }
    globalSharedPreference.setBool('isPostFavorite', true);

    SharedPreferencesRepository.setFavoritePosts(
        favoritePostsList: updatedFavoritePosts);
    emit(PostFavoriteState(favoritePosts: updatedFavoritePosts));
  }

  void removeFromFavorites(dynamic post) {
    post.isFavorit = false;
    updatedFavoritePosts = state.favoritePosts
      ..removeWhere((jsonPost) =>
          Post.fromJson(jsonPost).postID == post.postID &&
          Post.fromJson(jsonPost).shopeID == post.shopeID &&
          Post.fromJson(jsonPost).ownerID == post.ownerID);
    globalSharedPreference.setBool('isPostFavorite', false);

    SharedPreferencesRepository.setFavoritePosts(
        favoritePostsList: updatedFavoritePosts);
    emit(PostFavoriteState(favoritePosts: updatedFavoritePosts));
  }

  bool isPostFavorite(dynamic post) =>
      state.favoritePosts.contains(post.toJson());
}
