import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../data/repositories/posts_repository.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit() : super(AddPostInitial());

  Future addPost(
      {required String postImageType,
      required String shopeID,
      required String title,
      required String description,
      required String? postImage,
      required String category,
      required String price}) async {
    emit(AddPostProgress());
    String response = await PostsRepository().addPost(
        shopeID: shopeID,
        postImageType: postImageType,
        ownerID: globalSharedPreference.getString("ID")!,
        name: title,
        description: description,
        photos: postImage,
        category: category,
        price: price);
    if (response == "Failed") {
      emit(AddPostFailed(message: LocaleKeys.add_post_failed.tr()));
    } else {
      emit(AddPostSucceed());
    }
  }
}
