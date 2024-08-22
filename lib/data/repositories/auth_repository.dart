import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopesapp/constant/endpoint.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/models/user.dart';
import 'package:shopesapp/main.dart';

class AuthRepository {
  Future<Map<String, dynamic>?> userSignUp(String userName, String email,
      String password, String phoneNumber) async {
    http.Response response;
    Map<String, dynamic> requestBody;
    requestBody = {
      "name": userName,
      "emil": email,
      "password": password,
      "phoneNumber": phoneNumber,
      //  "lang": globalSharedPreference.getString("currentLanguage") ?? "en"
    };
    var uri = Uri.http(ENDPOINT, "/users/signup");

    try {
      response = await http.post(uri,
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 202) {
      Map<String, dynamic> parsedResult = jsonDecode(response.body);

      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> ownerSignUp({
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
    http.Response response;
    Map<String, dynamic> requestBody;
    requestBody = {
      "name": ownerName,
      "emil": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "storeName": storeName,
      "storeLocation": storeLocation,
      "storeCategory": storeCategory,
      "startWorkTime": startWorkTime,
      "endWorkTime": endWorkTime,
      "shopPhoneNumber": shopPhoneNumber,
      "latitude": latitude,
      "longitude": longitude,
      //  "lang": globalSharedPreference.getString("currentLanguage") ?? "en"
    };
    //print(requestBody);
    var uri = Uri.http(ENDPOINT, "/owners/signup");

    try {
      response = await http.post(uri,
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return null;
    }

    if (response.statusCode == 201) {
      Map<String, dynamic> parsedResult = jsonDecode(response.body);

      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> login(
      {required String email, required String password}) async {
    http.Response response;
    Map<String, dynamic> requestBody;
    Map<String, dynamic> parsedResult;
    requestBody = {
      "email": email,
      "password": password,
      //    "lang": globalSharedPreference.getString("currentLanguage") ?? "en"
    };
    try {
      var uri = Uri.http(ENDPOINT, "/login");
      response = await http.post(
        uri,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);

      return parsedResult;
    }

    return null;
  }

  Future<String?> verifyPassword(
      {required String password, required String id}) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": id,
      "password": password,
      //  "lang": globalSharedPreference.getString("currentLanguage") ?? "en"
    };
    try {
      response = await http.post(Uri.http(ENDPOINT, "/verifyPassword/$id"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return "MisMatched";
    }
    if (response.statusCode == 200 || response.statusCode == 202) {
      return "Matched";
    }
    return "MisMatched";
  }

  Future<Map<String, dynamic>?> getStoredOwnerAndShop() async {
    final prefs = await SharedPreferences.getInstance();
    String? ownerID,
        ownerName,
        ownerEmail,
        ownerPhoneNumber,
        shopCategory,
        shopID,
        endWorkTime,
        location,
        shopName,
        shopPhoneNumber,
        shopProfileImage,
        shopCoverImage,
        shopDescription,
        startWorkTime;
    List<dynamic>? socialUrl;
    double latitude, longitude;

    int? followesNumber;

    double? rate;
    socialUrl = prefs.getStringList("socialUrl");
    rate = prefs.getDouble("rate");
    followesNumber = prefs.getInt("followesNumber");
    shopDescription = prefs.getString("shopDescription");
    shopCoverImage = prefs.getString("shopCoverImage");
    shopPhoneNumber = prefs.getString("shopPhoneNumber");
    shopProfileImage = prefs.getString("shopProfileImage");
    ownerID = prefs.getString("ID");
    ownerEmail = prefs.getString("email");
    ownerPhoneNumber = prefs.getString("phoneNumber");
    ownerName = prefs.getString("name");
    shopID = prefs.getString("shopID");
    shopName = prefs.getString("shopName");
    shopCategory = prefs.getString("shopCategory");
    endWorkTime = prefs.getString("endWorkTime");
    startWorkTime = prefs.getString("startWorkTime");
    location = prefs.getString("location");
    latitude = prefs.getDouble("latitude")!;
    longitude = prefs.getDouble("longitude")!;
    if (ownerID != null &&
        ownerEmail != null &&
        ownerPhoneNumber != null &&
        ownerName != null &&
        shopID != null &&
        shopCategory != null &&
        startWorkTime != null &&
        endWorkTime != null &&
        location != null &&
        shopName != null) {
      return {
        "shop": Shop(
          ownerEmail: ownerEmail,
          ownerID: ownerID,
          ownerPhoneNumber: ownerPhoneNumber,
          ownerName: ownerName,
          shopCategory: shopCategory,
          shopID: shopID,
          startWorkTime: startWorkTime,
          endWorkTime: endWorkTime,
          location: location,
          shopName: shopName,
          shopPhoneNumber: shopPhoneNumber,
          shopProfileImage: shopProfileImage,
          shopCoverImage: shopCoverImage,
          shopDescription: shopDescription,
          followesNumber: followesNumber,
          rate: rate,
          socialUrl: socialUrl,
          latitude: latitude,
          longitude: longitude,
        ),
      };
    }
    return null;
  }

  Future<void> deleteInfo() async {
    globalSharedPreference.clear();
  }

  void saveOwnerAndShop({required Shop shop}) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> socialUrl = [];
    if (shop.socialUrl!.isEmpty) {
      shop.socialUrl!.add("");
      shop.socialUrl!.add("");
    }
    socialUrl.add(shop.socialUrl![0]);
    socialUrl.add(shop.socialUrl![1]);
    await prefs.setString("shopPhoneNumber", shop.shopPhoneNumber ?? "null");
    await prefs.setString("shopProfileImage", shop.shopProfileImage ?? "null");
    await prefs.setString("shopCoverImage", shop.shopCoverImage ?? "null");
    await prefs.setString("shopDescription", shop.shopDescription ?? "null");
    await prefs.setStringList("socialUrl", socialUrl);
    await prefs.setDouble("rate", shop.rate ?? 0);
    await prefs.setInt("followesNumber", shop.followesNumber ?? 0);
    await prefs.setString("ID", shop.ownerID);
    await prefs.setString("email", shop.ownerEmail);
    await prefs.setString("phoneNumber", shop.ownerPhoneNumber);
    await prefs.setString("name", shop.ownerName);
    await prefs.setString("shopName", shop.shopName);
    await prefs.setString("shopCategory", shop.shopCategory);
    await prefs.setString("location", shop.location);
    await prefs.setString("startWorkTime", shop.startWorkTime);
    await prefs.setString("endWorkTime", shop.endWorkTime);
    await prefs.setString("shopID", shop.shopID);
    await prefs.setString("mode", "owner");
    globalSharedPreference.setBool("isActive", shop.isActive);
    globalSharedPreference.setDouble("latitude", shop.latitude);
    globalSharedPreference.setDouble("longitude", shop.longitude);
  }

  void saveUser({required User user}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("ID", user.id);
    await prefs.setString("email", user.email);
    await prefs.setString("phoneNumber", user.phoneNumber);
    await prefs.setString("name", user.name);
    await prefs.setString("mode", "user");
  }
}
