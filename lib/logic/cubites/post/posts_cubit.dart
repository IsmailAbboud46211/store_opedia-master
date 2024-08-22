import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/data/models/post.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../data/repositories/posts_repository.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  List<dynamic> newestPosts = [];
  List<dynamic> oldestPosts = [];

  List<dynamic> ownerPosts = [];

  void setOwnerPost({required var posts}) {
    ownerPosts.clear();
    // print(ownerPosts);
    for (var element in posts) {
      ownerPosts.add(Post.fromMap(element));
    }
  }

  PostsCubit() : super(PostsInitial());

/*  Future getPosts() async {
//Test the internet Cubit check tht connection
    emit(FeatchingPostsProgress());
    BlocListener<InternetCubit, InternetState>(
      listener: (context, state) async {
        if (state is InternetConnected) {
          Map<String, dynamic>? response = await PostsRepository().getPosts();
          if (response!["message"] == "Success") {
            newestPosts = response["posts"] as List;
            if (newestPosts.isEmpty) {
              emit(NoPostYet());
            } else {
              emit(PostsFetchedSuccessfully());
            }
          } else {
            emit(ErrorFetchingPosts(message: response["message"]));
          }
        } else if (state is InternetDisconnected) {
          const Center(
              child: CustomText(
            text: 'No Internet Connected',
          ));
        } else {
          const CircularProgressIndicator();
        }
      },
    );
  }*/

  Future getOwnerPosts({
    required String? ownerID,
    required String? shopID,
    // required String? visitorID,
  }) async {
    emit(FeatchingPostsProgress());
    Map<String, dynamic>? response = await PostsRepository().getShopPosts(
      ownerID: ownerID!,
      shopID: shopID!,
      // visitorID: visitorID!,
    );
    if (response!["message"] == "Done") {
      newestPosts = response["posts"] as List;
      //    print(newestPosts);
      if (newestPosts.isEmpty) {
        emit(NoPostsYet());
      } else {
        setOwnerPost(posts: response["posts"]);
        emit(PostsFetchedSuccessfully());
      }
    } else {
      emit(ErrorFetchingPosts(message: response["message"]));
    }
  }

  Future getAllPosts({
    required String userID,
  }) async {
    emit(FeatchingPostsProgress());
    Map<String, dynamic>? response = await PostsRepository().getAllPosts();
    if (response == null) {
      emit(ErrorFetchingPosts(message: LocaleKeys.get_posts_failed.tr()));
    } else if (response["message"] == "You dont have any followed store yet") {
      emit(NoPostsYet());
    } else if (response["message"] == "Done") {
      emit(PostsFetchedSuccessfully());
    } else {
      emit(ErrorFetchingPosts(message: response["message"]));
    }
  }

  Future getOldestPosts() async {
    emit(FeatchingPostsProgress());
    if (newestPosts.isEmpty) {
      emit(NoPostsYet());
    } else {
      oldestPosts = List.from(newestPosts.reversed);
      emit(OldestPostsFiltered());
    }
  }
}
