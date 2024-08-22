import 'dart:convert';

import 'package:shopesapp/data/enums/data_type.dart';
import 'package:shopesapp/data/models/owner.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/main.dart';

class SharedPreferencesRepository {
  static String PREF_CURRENT_STORE = "current Owner Store";
  static String PREF_FAVORITE_STORES = "favorite Stores List";
  static String PREF_FAVORITE_POSTS = "favorite posts List";
  static String PREF_FOLLOWED_POSTS = "followed posts List";
  static String PREF_POST_RATING = " post rating ";
  static String PREF_STORE_RATING = " Store rating ";
  static String PREF_STORE_FOLLOWERS = " Store FOLLOWERS number ";
  static String PREF_Browsing_Mode = "browsing mode";

  static void setBrowsingPostsMode({required bool isBrowsingMode}) {
    setPreference(
        dataType: DataType.BOOLEAN,
        key: PREF_Browsing_Mode,
        value: isBrowsingMode);
  }

  static bool getBrowsingPostsMode() {
    if (globalSharedPreference.containsKey(PREF_Browsing_Mode)) {
      return getPreference(
        key: PREF_Browsing_Mode,
      );
    } else {
      return false;
    }
  }

  static void setStoreFollowers(int count, Shop shop) {
    setPreference(
        dataType: DataType.INT, key: shop.ownerID + shop.shopID, value: count);
  }

  static int getStoreFollowers(Shop shop) {
    if (globalSharedPreference.containsKey(shop.ownerID + shop.shopID)) {
      return getPreference(
        key: shop.ownerID + shop.shopID,
      );
    } else {
      return 0;
    }
  }

  static void saveCurrentOwnerStore({required Shop shop}) {
    setPreference(
        dataType: DataType.STRING,
        key: PREF_CURRENT_STORE,
        value: json.encode(shop));
  }

  static void saveOwner(Owner owner) {
    setPreference(
        dataType: DataType.STRING,
        key: '${owner.name}/${owner.id}',
        value: json.encode(owner));
  }

  static Owner? getSavedOwner(Owner owner) {
    if (globalSharedPreference.containsKey('${owner.name}/${owner.id}')) {
      return Owner.fromJson(json.decode(getPreference(
        key: '${owner.name}/${owner.id}',
      )));
    } else {
      return null;
    }
  }

  static void saveShop(Shop shop) {
    setPreference(
        dataType: DataType.STRING,
        key: '${shop.ownerID}/${shop.shopID}',
        value: json.encode(shop));
  }

  static Shop? getSavedShop(Shop shop) {
    if (globalSharedPreference.containsKey('${shop.ownerID}/${shop.shopID}')) {
      return Shop.fromJson(json.decode(getPreference(
        key: '${shop.ownerID}/${shop.shopID}',
      )));
    } else {
      return null;
    }
  }

  static Shop? getCurrentOwnerStore() {
    if (globalSharedPreference.containsKey(PREF_CURRENT_STORE)) {
      return Shop.fromJson(json.decode(getPreference(
        key: PREF_CURRENT_STORE,
      )));
    } else {
      return null;
    }
  }

  static void setStoreRate(
      {required String ownerId, required String shopId, required double rate}) {
    setPreference(
        dataType: DataType.DOUBLE, key: '$shopId+$ownerId', value: rate);
  }

  static double getStoreRate(
      {required String ownerId, required String shopId}) {
    if (globalSharedPreference.containsKey('$shopId+$ownerId')) {
      return getPreference(
        key: '$shopId+$ownerId',
      );
    } else {
      return 0;
    }
  }

  static void setPostRate(
      {required String ownerId,
      required String shopId,
      required String postId,
      required double rate}) {
    setPreference(
        dataType: DataType.DOUBLE,
        key: '$ownerId+$shopId+$postId',
        value: rate);
  }

  static double getPostRate(
      {required String ownerId,
      required String shopId,
      required String postId}) {
    if (globalSharedPreference.containsKey('$ownerId+$shopId+$postId')) {
      return getPreference(
        key: '$ownerId+$shopId+$postId',
      );
    } else {
      return 0;
    }
  }

  static void setFollowedStores({required List<dynamic> followedShopsList}) {
    setPreference(
        dataType: DataType.STRING,
        key: PREF_FOLLOWED_POSTS,
        value: json.encode(followedShopsList));
  }

  static List<dynamic> getFollowedStores() {
    if (globalSharedPreference.containsKey(PREF_FOLLOWED_POSTS)) {
      return json.decode(getPreference(
        key: PREF_FOLLOWED_POSTS,
      ));
    } else {
      return [];
    }
  }

  static void setFavoriteStores({required List<dynamic> favoriteShopsList}) {
    setPreference(
        dataType: DataType.STRING,
        key: PREF_FAVORITE_STORES,
        value: json.encode(favoriteShopsList));
  }

  static List<dynamic> getFavoriteStores() {
    if (globalSharedPreference.containsKey(PREF_FAVORITE_STORES)) {
      return json.decode(getPreference(
        key: PREF_FAVORITE_STORES,
      ));
    } else {
      return [];
    }
  }

  static void setFavoritePosts({required List<dynamic> favoritePostsList}) {
    setPreference(
        dataType: DataType.STRING,
        key: PREF_FAVORITE_POSTS,
        value: json.encode(favoritePostsList));
  }

  static List<dynamic> getFavoritePosts() {
    if (globalSharedPreference.containsKey(PREF_FAVORITE_POSTS)) {
      return json.decode(getPreference(
        key: PREF_FAVORITE_POSTS,
      ));
    } else {
      return [];
    }
  }

  static setPreference({
    required DataType dataType,
    required String key,
    required dynamic value,
  }) async {
    switch (dataType) {
      case DataType.INT:
        await globalSharedPreference.setInt(key, value);
        break;
      case DataType.DOUBLE:
        await globalSharedPreference.setDouble(key, value);
        break;
      case DataType.STRINGLIST:
        await globalSharedPreference.setStringList(key, value);
        break;
      case DataType.STRING:
        await globalSharedPreference.setString(key, value);
        break;
      case DataType.BOOLEAN:
        await globalSharedPreference.setBool(key, value);
        break;
    }
  }

  static dynamic getPreference({required String key}) {
    return globalSharedPreference.get(key);
  }
}
