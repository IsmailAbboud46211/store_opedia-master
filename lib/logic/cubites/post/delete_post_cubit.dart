import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/data/repositories/posts_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'delete_post_state.dart';

class DeletePostCubit extends Cubit<DeletePostState> {
  DeletePostCubit() : super(DeletePostInitial());
  Future deletePost(
      {required String postID,
      required String shopID,
      required String ownerID}) async {
    emit(DeletePostProgress());
    String response = await PostsRepository()
        .deletePost(postID: postID, shopID: shopID, ownerID: ownerID);
    if (response == "Failed") {
      emit(DeletePostFailed(message: LocaleKeys.delete_post_failed.tr()));
    } else {
      emit(DeletePostSucceed());
    }
  }
}
