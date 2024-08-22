// ignore_for_file: overridden_fields

part of 'show_favorite_stores_cubit.dart';

class ShowFavoriteStoresState {
  List<dynamic> favoriteStores;
  ShowFavoriteStoresState({required this.favoriteStores});
}

class ShowFavoriteStoresInitial extends ShowFavoriteStoresState {
  ShowFavoriteStoresInitial() : super(favoriteStores: []);
}

class ShowFavoriteStoresFailed extends ShowFavoriteStoresState {
  String message;
  ShowFavoriteStoresFailed({required this.message}) : super(favoriteStores: []);
}

class ShowFavoriteStoresSuccessed extends ShowFavoriteStoresState {
  @override
  List<dynamic> favoriteStores;
  ShowFavoriteStoresSuccessed({required this.favoriteStores})
      : super(favoriteStores: favoriteStores);
}

class NoFavoriteStores extends ShowFavoriteStoresState {
  NoFavoriteStores() : super(favoriteStores: []);
}

class ShowFavoriteStoresProgress extends ShowFavoriteStoresState {
  ShowFavoriteStoresProgress() : super(favoriteStores: []);
}
