import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/data/repositories/shop_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'search_store_state.dart';

class SearchStoreCubit extends Cubit<SearchStoreState> {
  List<dynamic> searchResult = [];
  SearchStoreCubit() : super(SearchStoreInitial(searchResult: []));
  Future searchStore({required String ownerID, required String search}) async {
    emit(SearchStoreProgress());
    Map<String, dynamic>? response;
    try {
      response =
          await ShopRepository().searchStore(ownerID: ownerID, search: search);
    } catch (e) {
      emit(SearchStoreFailed(
          message: response == null
              ? LocaleKeys.search_failed.tr()
              : response["message"]));
    }
    if (response != null && response['message'] == 'Done') {
      searchResult = response['stores'] as List<dynamic>;
      SearchStoreState(searchResult: searchResult);
      searchResult.isEmpty
          ? emit(NoSearchResult())
          : emit(SearchStoreSuccessed(searchResult: searchResult));
    } else if (response != null && response['message'] == '') {
      emit(NoSearchResult());
    }
  }
}
