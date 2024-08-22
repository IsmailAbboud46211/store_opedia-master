import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/data/repositories/filter_repository.dart';
import 'package:shopesapp/data/repositories/posts_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  List<dynamic> filteredPosts = [];
  FilterCubit() : super(FilterInitial());

  Future filterPostsWithCategory(
      {required String category, bool onlyShowSubcategories = false}) async {
    //check the internetCubit
    // postsFilterdWithCategory.clear();

    Map<String, dynamic>? response;
    emit(FilterProgress());
    try {
      response = await FilterRepository()
          .getPostsFilteredWithCategory(category: category);
    } catch (e) {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
    // if (response == null) emit(FilterFailed(message: 'Failed'));
    if (response != null && response["message"] == "Success") {
      filteredPosts = response["posts"] as List;
      List<String> subCategries = response["subCategories"] as List<String>;
      if (filteredPosts.isEmpty) {
        emit(NoPostYet());
      }
      if (subCategries.isEmpty && onlyShowSubcategories) {
        emit(NoSubCategories());
      } else {
        emit(FilterState(filteredPosts: filteredPosts));

        emit(FilteredSuccessfully());
        if (subCategries.isNotEmpty && onlyShowSubcategories) {
          emit(CategoriesFilteredSuccessfully(subCategories: subCategries));
        }
      }
    } else {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
  }

  Future filterPostsWithRatings({
    required String id,
    required String type,
  }) async {
    //check the internetCubit
    emit(FilterProgress());
    Map<String, dynamic>? response;
    //   await FilterRepository().getPostsFilteredWithRatings();
    try {
      response = await FilterRepository()
          .getPostsFilteredWithRatings(id: id, type: type);
    } catch (e) {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
    if (response != null && response["message"] == "Success") {
      filteredPosts = response["posts"] as List<dynamic>;
      if (filteredPosts.isEmpty) {
        emit(NoPostYet());
      } else {
        emit(FilterState(filteredPosts: filteredPosts));
        emit(FilteredSuccessfully());
      }
    } else {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
  }

  Future filterPostsWithLocation({required String location}) async {
    //check the internetCubit
    // filteredPosts.clear();
    Map<String, dynamic>? response;
    emit(FilterProgress());
    try {
      response = await FilterRepository()
          .getPostsFilteredWithLocation(location: location);
    } catch (e) {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
    // if (response == null) emit(FilterFailed(message: 'Failed'));
    if (response != null && response["message"] == "Success") {
      filteredPosts = response["posts"] as List;
      if (filteredPosts.isEmpty) {
        emit(NoPostYet());
      } else {
        emit(FilterState(filteredPosts: filteredPosts));
        emit(FilteredSuccessfully());
      }
    } else {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
  }

  Future filterWithOldestPosts({
    required String id,
    required String type,
  }) async {
    //check the internetCubit
    emit(FilterProgress());
    Map<String, dynamic>? response;
    //   await FilterRepository().getPostsFilteredWithRatings();
    try {
      response = await FilterRepository()
          .getPostsFilteredWithRatings(id: id, type: type);
    } catch (e) {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
    if (response != null && response["message"] == "Success") {
      filteredPosts = response["posts"] as List<dynamic>;
      if (filteredPosts.isEmpty) {
        emit(NoPostYet());
      } else {
        emit(FilterState(filteredPosts: filteredPosts));
        emit(FilteredSuccessfully());
      }
    } else {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
  }

  Future getAllPosts() async {
    //check the internetCubit
    // filteredPosts.clear();
    Map<String, dynamic>? response;
    emit(FilterProgress());
    try {
      response = await PostsRepository().getAllPosts();
    } catch (e) {
      emit(FilterFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
    // if (response == null) emit(FilterFailed(message: 'Failed'));

    if (response == null) {
      emit(FilterFailed(message: LocaleKeys.get_posts_failed.tr()));
    } else if (response["message"] == "You dont have any followed store yet") {
      emit(DontFollowStoreYet());
    } else if (response["message"] == "You dont have any post to show  yet") {
      emit(NoPostYet());
    } else if (response["message"] == "Done") {
      filteredPosts = response["posts"];
      emit(FilteredSuccessfully());
    } else {
      emit(FilterFailed(message: response["message"]));
    }
  }

  void getOldestPosts() {}
}
