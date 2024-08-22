import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopesapp/constant/endpoint.dart';

class ShopRepository {
  Future<Map<String, dynamic>?> sendShopRating({
    required String userID,
    required String shopID,
    required double rateValue,
  }) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": userID,
      "shopID": shopID,
      "value": rateValue,
    };
    //  print(requestBody);
    try {
      response = await http.post(Uri.http(ENDPOINT, "rate/$userID/$shopID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 400) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getOwnerShpos(
      {required String? ownerID, required String message}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "message": message,
    };

    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/store/activation/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }

    return null;
  }

  Future<Map<String, dynamic>?> getShops({required String? ownerID}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "ownerID": ownerID,
    };
    try {
      response = await http.post(Uri.http(ENDPOINT, "/show/stores/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }

    return null;
  }

  Future<Map<String, dynamic>?> getShop({required String? shopID}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "shopID": shopID,
    };
    try {
      response = await http.post(Uri.http(ENDPOINT, "/store/details/$shopID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }

    return null;
  }

  Future<String> addShop({
    required String? facebookAccount,
    required String? instagramAccount,
    required String ownerID,
    required String shopName,
    required String shopDescription,
    required String? shopProfileImage,
    required String? shopCoverImage,
    required String shopCategory,
    required String location,
    required String closing,
    required String opening,
    required String shopPhoneNumber,
    required double latitude,
    required double longitude,
    required String storeProfileImageType,
    required String storeCoverImageType,
  }) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "name": shopName,
      "description": shopDescription,
      "profile_photo": shopProfileImage ?? "noImage",
      "cover_photo": shopCoverImage ?? "noImage",
      "category": shopCategory,
      "address": location,
      "facebook": facebookAccount,
      "insta": instagramAccount,
      "opening": opening,
      "closing": closing,
      "rate": 0,
      "phone": shopPhoneNumber,
      "latitude": latitude,
      "longitude": longitude,
      "storeCoverImageType": storeCoverImageType,
      "storeProfileImageType": storeProfileImageType,
    };

    try {
      response = await http.post(Uri.http(ENDPOINT, "/AddStore/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return "Faild";
    }
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Faild";
  }

  Future<String> deleteShop(
      {required String shopID, required String ownerID}) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "shopID": shopID,
    };

    try {
      response = await http.delete(Uri.http(ENDPOINT, "/delete/store/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return "Failed";
    }
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<dynamic> editShop({
    required String ownerID,
    required String shopID,
    required String shopName,
    required String shopDescription,
    required String? shopProfileImage,
    required String? shopCoverImage,
    required String shopCategory,
    required String location,
    required String endWorkTime,
    required String startWorkTime,
    String? insta,
    String? facebook,
    required String shopPhoneNumber,
    required double latitude,
    required double longitude,
    required String storeProfileImageType,
    required String storeCoverImageType,
  }) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "shopName": shopName,
      "shopDescription": shopDescription,
      "shopProfileImage": shopProfileImage ?? "noImage",
      "shopCoverImage": shopCoverImage ?? "noImage",
      "shopCategory": shopCategory,
      "location": location,
      "startWorkTime": startWorkTime,
      "endWorkTime": endWorkTime,
      "insta": insta ?? "insta",
      "facebook": facebook ?? "facebook",
      "shopPhoneNumber": shopPhoneNumber,
      "id": ownerID,
      "shopID": shopID,
      "storeCoverImageType": storeCoverImageType,
      "storeProfileImageType": storeProfileImageType,
    };
    try {
      response = await http.put(Uri.http(ENDPOINT, "/profile/store/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return "Faild";
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return "Faild";
  }

  Future<Map<String, dynamic>?> getRelatedShops(
      {required String location}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    try {
      response = await http
          .get(Uri.http(ENDPOINT, "/shops/locations/$location"), headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAllStores({required String id}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {"id": id};

    try {
      response = await http.post(Uri.http(ENDPOINT, "/show/stores/$id"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> filterStores(
      {required String id, required String type}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": id,
      "type": type,
    };
    // print(requestBody);
    try {
      response = await http.post(Uri.http(ENDPOINT, "/filters/$id"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
//    print(response.statusCode);
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> locationFilterStores(
      {required String id,
      required double longitude,
      required double latitude}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": id,
      "longitude": longitude.toString(),
      "latitude": latitude.toString(),
    };
    // print(requestBody);
    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/filters/nearestStores/$id"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> cityFilterStores({
    required String id,
    required String address,
  }) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": id,
      "address": address,
    };
    //  print(requestBody);
    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/filters/stores/location/$id"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    //   print(response.statusCode);
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> categoryFilterStores({
    required String id,
    required String category,
  }) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": id,
      "category": category,
    };
    //  print(requestBody);
    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/show/stores/categories/$id"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    //   print(response.statusCode);
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<String?> toggleActivation(
      {required String shopID, required String ownerID}) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "shopId": shopID,
    };

    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/store/toggleActivation/$shopID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return "Faild";
    }
    if (response.statusCode == 200) {
      //  print(parsedResult);
      return "Success";
    }
    return "Faild";
  }

  Future<Map<String, dynamic>?> toggoleFollowShop(
      {required String shopID, required String userID}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": userID,
      "shopId": shopID,
    };
    //   print(requestBody);
    try {
      response = await http.post(Uri.http(ENDPOINT, "/follow/$userID/$shopID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }

    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      //  print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> toggoleFavoriteShop(
      {required String shopID, required String ownerID}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "shopId": shopID,
    };

    try {
      response = await http.post(Uri.http(ENDPOINT, "/fav/$ownerID/$shopID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> showFavoriteStores(
      {required String ownerID}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
    };

    try {
      response = await http.post(Uri.http(ENDPOINT, "show/my/fav/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>?> searchStore(
      {required String ownerID, required String search}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "search": search,
    };

    try {
      response = await http.post(Uri.http(ENDPOINT, "search/stores/$ownerID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //   print(response.statusCode);
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }
    return null;
  }
}
