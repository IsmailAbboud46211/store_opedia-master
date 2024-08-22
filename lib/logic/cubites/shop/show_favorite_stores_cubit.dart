// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../data/repositories/shop_repository.dart';

part 'show_favorite_stores_state.dart';

class ShowFavoriteStoresCubit extends Cubit<ShowFavoriteStoresState> {
  List<dynamic> favoriteStores = [];
  ShowFavoriteStoresCubit() : super(ShowFavoriteStoresInitial());
  Future showMyFavoriteStores({required String ownerID}) async {
    emit(ShowFavoriteStoresProgress());
    Map<String, dynamic>? response;
    try {
      response = await ShopRepository().showFavoriteStores(ownerID: ownerID);
    } catch (e) {
      emit(ShowFavoriteStoresFailed(
          message: response == null
              ? LocaleKeys.filter_repo_failed.tr()
              : response["message"]));
    }
    if (response != null && response['message'] == 'Done') {
      favoriteStores = response['favs'] as List<dynamic>;
      ShowFavoriteStoresState(favoriteStores: favoriteStores);
      emit(ShowFavoriteStoresSuccessed(favoriteStores: favoriteStores));
    } else if (response != null &&
        response['message'] == 'You dont have any favourite stores yet') {
      emit(NoFavoriteStores());
    }
  }
}
