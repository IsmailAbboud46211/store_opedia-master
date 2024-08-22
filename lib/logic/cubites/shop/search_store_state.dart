// ignore_for_file: overridden_fields

part of 'search_store_cubit.dart';

class SearchStoreState {
  final List<dynamic> searchResult;
  SearchStoreState({required this.searchResult});
}

class SearchStoreInitial extends SearchStoreState {
  SearchStoreInitial({required List searchResult})
      : super(searchResult: searchResult);
}

class SearchStoreFailed extends SearchStoreState {
  String message;
  SearchStoreFailed({required this.message}) : super(searchResult: []);
}

class SearchStoreSuccessed extends SearchStoreState {
  @override
  List<dynamic> searchResult;
  SearchStoreSuccessed({required this.searchResult})
      : super(searchResult: searchResult);
}

class NoSearchResult extends SearchStoreState {
  NoSearchResult() : super(searchResult: []);
}

class SearchStoreProgress extends SearchStoreState {
  SearchStoreProgress() : super(searchResult: []);
}
