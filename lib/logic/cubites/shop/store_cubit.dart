import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/repositories/shop_repository.dart';
import 'package:shopesapp/main.dart';

import '../../../translation/locale_keys.g.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  late Shop shop;
  List<dynamic> shops = [];
  List<dynamic> oldshops = [];
  StoreCubit() : super(ShopsInitial());

  Future getAllStores() async {
    emit(FeatchingShopsProgress());
    Map<String, dynamic>? response;

    response = await ShopRepository()
        .getAllStores(id: globalSharedPreference.getString("ID") ?? '0');

    if (response == null) {
      emit(ErrorFetchingShops(message: LocaleKeys.get_stores_failed.tr()));
    } else if (response["message"] != "Done" &&
        response["message"] != "No Stores Yet") {
      emit(NoShopsYet());
    } else if (response["message"] == "Done") {
      shops = response["stores"];
      emit(FeatchingShopsSucceed());
    } else {
      emit(ErrorFetchingShops(message: response["message"]));
    }
  }

  Future filterStores({
    required String id,
    required String type,
  }) async {
    emit(FeatchingShopsProgress());

    Map<String, dynamic>? response;

    response = await ShopRepository().filterStores(id: id, type: type);

    if (response == null) {
      emit(ErrorFetchingShops(message: LocaleKeys.get_stores_failed.tr()));
    } else if (response["message"] != "Done" &&
        response["message"] != "No Stores Yet") {
      emit(NoShopsYet());
    } else if (response["message"] == "Done") {
      shops = response["stores"];
      emit(FeatchingShopsSucceed());
    } else {
      emit(ErrorFetchingShops(message: response["message"]));
    }
  }

  Future locationFilterStores(
      {required String id,
      required double longitude,
      required double latitude}) async {
    emit(FeatchingShopsProgress());

    Map<String, dynamic>? response;

    response = await ShopRepository()
        .locationFilterStores(id: id, latitude: latitude, longitude: longitude);

    if (response == null) {
      emit(ErrorFetchingShops(message: LocaleKeys.get_stores_failed.tr()));
    } else if (response["message"] != "Done") {
      emit(NoShopsYet());
    } else if (response["message"] == "Done") {
      shops = response["stores"];
      if (shops.isEmpty) {
        emit(NoShopsYet());
      } else {
        emit(FeatchingShopsSucceed());
      }
    } else {
      emit(ErrorFetchingShops(message: response["message"]));
    }
  }

  Future cilyFilterStores({
    required String id,
    required String address,
  }) async {
    emit(FeatchingShopsProgress());

    Map<String, dynamic>? response;

    response =
        await ShopRepository().cityFilterStores(id: id, address: address);

    if (response == null) {
      emit(ErrorFetchingShops(message: LocaleKeys.get_stores_failed.tr()));
    } else if (response["message"] != "Done") {
      emit(NoShopsYet());
    } else if (response["message"] == "Done") {
      shops = response["stores"];
      emit(FeatchingShopsSucceed());
    } else {
      emit(ErrorFetchingShops(message: response["message"]));
    }
  }

  Future categoryFilterStores({
    required String id,
    required String category,
  }) async {
    emit(FeatchingShopsProgress());

    Map<String, dynamic>? response;

    response =
        await ShopRepository().categoryFilterStores(id: id, category: category);

    if (response == null) {
      emit(ErrorFetchingShops(message: LocaleKeys.get_stores_failed.tr()));
    } else if (response["message"] != "Done") {
      emit(NoShopsYet());
    } else if (response["message"] == "Done") {
      shops = response["stores"];
      emit(FeatchingShopsSucceed());
    } else {
      emit(ErrorFetchingShops(message: response["message"]));
    }
  }
}
