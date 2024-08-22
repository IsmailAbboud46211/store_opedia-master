import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/data/repositories/posts_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'toggle_post_favorite_state.dart';

class TogglePostFavoriteCubit extends Cubit<TogglePostFavoriteState> {
  TogglePostFavoriteCubit() : super(ToggoleFavoritePostInitial());

  Future toggolePostFavorite({
    required String postID,
    required String userID,
  }) async {
    emit(ProgressToggoleFavoritePost());
    Map<String, dynamic>? response = await PostsRepository()
        .toggoleFavoritePost(postID: postID, userID: userID);
    if (response == null || response["message"] == "Access Denied") {
      ScaffoldMessenger(
          child: Text(response == null
              ? LocaleKeys.fav_post_failed.tr()
              : response["message"]));
      emit(FailedToggoleFavoritePost(response == null
          ? LocaleKeys.fav_post_failed.tr()
          : response["message"]));
    } else {
      const ScaffoldMessenger(child: Text('Add Sccuueded!'));
      emit(SucceedToggoleFavoritePost(message: response["message"]));
    }
  }
}
