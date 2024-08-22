import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/data/repositories/auth_repository.dart';
import 'package:shopesapp/logic/cubites/user/auth_state.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../../data/models/shop.dart';
import '../../../data/models/user.dart';
import '../../../data/data base/shared_preferences_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  User? user;
  Shop? shop;

//user signin
  Future userSignUp(String userName, String email, String password,
      String phoneNumber) async {
    emit(AuthProgress());

    Map<String, dynamic>? response = await AuthRepository()
        .userSignUp(userName, email, password, phoneNumber);

    if (response == null) {
      emit(AuthFailed(LocaleKeys.sign_up_failed.tr()));
    } else if (response["message"] == "UserName Already Exists") {
      emit(AuthFailed(LocaleKeys.user_name_already_exists.tr()));
    } else if (response["message"] == "Email Already Exists") {
      emit(AuthFailed(LocaleKeys.email_already_exists.tr()));
    } else {
      user = User.fromMap(response);
      /*  if (globalSharedPreference.getBool("isDarkMode") == null) {
        globalSharedPreference.setBool("isDarkMode", false);
      }*/
      if (globalSharedPreference.getBool("isArabic") == null) {
        globalSharedPreference.setBool("isArabic", false);
      }
      SharedPreferencesRepository.setBrowsingPostsMode(isBrowsingMode: false);

      AuthRepository().saveUser(user: user!);
      emit(UserSignedUp());
    }
  }

//Owner signin
  Future ownerSignUp({
    required String ownerName,
    required String email,
    required String password,
    required String phoneNumber,
    required String storeLocation,
    required String storeCategory,
    required String startWorkTime,
    required String endWorkTime,
    required String storeName,
    required String shopPhoneNumber,
    required double latitude,
    required double longitude,
  }) async {
    emit(AuthProgress());

    Map<String, dynamic>? response = await AuthRepository().ownerSignUp(
      ownerName: ownerName,
      password: password,
      phoneNumber: phoneNumber,
      email: email,
      storeName: storeName,
      storeLocation: storeLocation,
      storeCategory: storeCategory,
      startWorkTime: startWorkTime,
      endWorkTime: endWorkTime,
      shopPhoneNumber: shopPhoneNumber,
      latitude: latitude,
      longitude: longitude,
    );
    if (response == null) {
      emit(AuthFailed(LocaleKeys.sign_up_failed.tr()));
    } else if (response["message"] == "UserName Already Exists") {
      emit(AuthFailed(LocaleKeys.user_name_already_exists.tr()));
    } else if (response["message"] == "Email Already Exists") {
      emit(AuthFailed(LocaleKeys.email_already_exists.tr()));
    } else if (response["message"] == 'Invalid Values') {
      emit(AuthFailed(LocaleKeys.invalid_values.tr()));
    } else {
      /*  if (globalSharedPreference.getBool("isDarkMode") == null) {
        globalSharedPreference.setBool("isDarkMode", false);
      }*/
      if (globalSharedPreference.getBool("isArabic") == null) {
        globalSharedPreference.setBool("isArabic", false);
      }
      emit(OwnerSignedUp());
      shop = Shop.fromMap(response);
      AuthRepository().saveOwnerAndShop(shop: shop!);

      SharedPreferencesRepository.setBrowsingPostsMode(isBrowsingMode: false);
    }
  }

  Future login(String email, String password) async {
    emit(AuthProgress());

    Map<String, dynamic>? response =
        await AuthRepository().login(email: email, password: password);

    if (response == null) {
      emit(AuthFailed(LocaleKeys.log_in_failed.tr()));
    } else if (response["message"] == 'Invalid Email Or Password') {
      emit(AuthFailed(LocaleKeys.invalid_email_or_password.tr()));
    } else if (response["message"] == "user auth succeded") {
      user = User.fromMap(response);

      AuthRepository().saveUser(user: user!);
      SharedPreferencesRepository.setBrowsingPostsMode(isBrowsingMode: false);
      emit(UserLoginedIn());
    } else if (response["message"] == "owner auth succeded") {
      /*  if (globalSharedPreference.getBool("isDarkMode") == null) {
        globalSharedPreference.setBool("isDarkMode", false);
      }*/
      if (globalSharedPreference.getBool("isArabic") == null) {
        globalSharedPreference.setBool("isArabic", false);
      }
      String ownerID = response["ownerID"];

      saveOwnerID(ownerID: ownerID);

      SharedPreferencesRepository.setBrowsingPostsMode(isBrowsingMode: false);

      emit(OwnerWillSelectStore());
    }
  }

  void userBecomeOwner() {
    globalSharedPreference.setString("mode", "owner");
    globalSharedPreference.setString("currentShop", "noShop");
    globalSharedPreference.setString("CurrentShopID", "noID");
    emit(OwnerLoginedIn());
  }

  void ownerBecomeUser() {
    emit(AuthProgress());

    globalSharedPreference.setString("mode", "user");
    globalSharedPreference.setString("currentShop", "shopDeleted");
    emit(UserLoginedIn());
  }

  void deleteCurrentShop() {
    globalSharedPreference.setString("currentShop", "noShop");
    globalSharedPreference.remove("shopPhoneNumber");
    globalSharedPreference.remove("shopProfileImage");
    globalSharedPreference.remove("shopCoverImage");
    globalSharedPreference.remove("numberOfFollowers");
    globalSharedPreference.remove("socialUrl");
    globalSharedPreference.remove("rate");
    globalSharedPreference.remove("shopDescription");
    globalSharedPreference.remove("shopCategory");
    globalSharedPreference.remove("location");
    globalSharedPreference.remove("latitude");
    globalSharedPreference.remove("longitude");
  }

  Future<void> autoLogIn() async {
    String? mode = globalSharedPreference.getString("mode");

    if (mode == null) {
      emit(NoAuthentication());
    } else if (mode == "user") {
      emit(UserLoginedIn());
    } else {
      emit(OwnerLoginedIn());
    }
  }

  void selectedShop() {
    globalSharedPreference.setString("currentShop", "ShopSelected");

    emit(OwnerLoginedIn());
  }

  void saveOwnerID({required String ownerID}) async {
    await globalSharedPreference.setString("ID", ownerID);
    await globalSharedPreference.setString("shopID", "noID");
  }

  Future<void> logOut() async {
    user = null;
    shop = null;
    await AuthRepository().deleteInfo();
    emit(NoAuthentication());
  }
}
