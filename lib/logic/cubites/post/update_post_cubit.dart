import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/data/repositories/posts_repository.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'update_post_state.dart';

class UpdatePostCubit extends Cubit<UpdatePostState> {
  UpdatePostCubit() : super(UpdatePostInitial());
  Future updatePost({
    required String postID,
    required String shopID,
    required String name,
    required String description,
    required String? photos,
    required String category,
    required String postImageType,
    required String price,
  }) async {
    emit(UpdatePostProgress());
    String response = await PostsRepository().updatePost(
        postID: postID,
        shopID: shopID,
        name: name,
        description: description,
        photos: photos,
        postImageType: postImageType,
        price: price,
        ownerID: globalSharedPreference.getString("ID")!);
    if (response == "Failed") {
      emit(UpdatePostFailed(message: LocaleKeys.update_post_failed.tr()));
    } else {
      emit(UpdatePostSucceed());
    }
  }
}
