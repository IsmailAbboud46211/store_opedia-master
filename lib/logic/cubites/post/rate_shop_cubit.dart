import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/data/repositories/posts_repository.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'rate_shop_state.dart';

class RatePostCubit extends Cubit<RatePostState> {
  RatePostCubit() : super(RatePostInitial(rate: 0));

  Future<void> setPostRating(
      {required double newRate,
      required String ownerId,
      required String shopId,
      required String postId}) async {
    if (newRate > 3.0) {
      String? response = await PostsRepository()
          .sendPostRating(ownerId, shopId, postId, newRate);

      SharedPreferencesRepository.setPostRate(
          ownerId: ownerId, shopId: shopId, rate: newRate, postId: postId);
      emit(RatePostState(rate: newRate));
      if (response == 'Success') {
        SharedPreferencesRepository.setPostRate(
            ownerId: ownerId, shopId: shopId, rate: newRate, postId: postId);
        emit(RatePostState(rate: newRate));
      } else {
        ScaffoldMessenger(
            child: Text(LocaleKeys
                .some_thing_went_wrong_check_your_internet_connection_and_try_again
                .tr()));
      }
    }
  }

  double getPostRating(
      {required String ownerId,
      required String shopId,
      required String postId}) {
    return SharedPreferencesRepository.getPostRate(
        ownerId: ownerId, shopId: shopId, postId: postId);
  }
}
