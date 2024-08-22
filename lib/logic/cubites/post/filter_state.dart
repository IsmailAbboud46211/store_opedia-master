part of 'filter_cubit.dart';

class FilterState {
  final List<dynamic> filteredPosts;
  FilterState({required this.filteredPosts});
}

class FilterInitial extends FilterState {
  FilterInitial() : super(filteredPosts: []);
}

class NoPostYet extends FilterState {
  NoPostYet() : super(filteredPosts: []);
}

class DontFollowStoreYet extends FilterState {
  DontFollowStoreYet() : super(filteredPosts: []);
}

class FilterProgress extends FilterState {
  FilterProgress() : super(filteredPosts: []);
}

class FilteredSuccessfully extends FilterState {
  FilteredSuccessfully() : super(filteredPosts: []);
}

class FilterFailed extends FilterState {
  String message;
  FilterFailed({required this.message}) : super(filteredPosts: []);
}

// class LocationsFilteredSuccessfully extends FilterState {
//   LocationsFilteredSuccessfully() : super(filteredPosts: []);
// }

// class RatingsFilteredSuccessfully extends FilterState {
//   RatingsFilteredSuccessfully() : super(filteredPosts: []);
// }
class NoSubCategories extends FilterState {
  NoSubCategories() : super(filteredPosts: []);
}

class CategoriesFilteredSuccessfully extends FilterState {
  List<String> subCategories;
  CategoriesFilteredSuccessfully({required this.subCategories})
      : super(filteredPosts: []);
}

// class FilterdWithOldestPosts extends FilterState {
//   FilterdWithOldestPosts() : super(filteredPosts: []);
// }
