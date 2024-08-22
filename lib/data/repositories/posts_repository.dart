import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopesapp/constant/endpoint.dart';

import '../../main.dart';

class PostsRepository {
  Future<String?> sendPostRating(
      String ownerId, String shopId, String postId, double rate) async {
    http.Response response;

    try {
      response =
          await http.post(Uri.http(ENDPOINT, "/$ownerId/$shopId/$postId"),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'postRate': rate}));
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      return 'Success';
    }
    return null;
  }

  Future<Map<String, dynamic>?> getShopPosts({
    required String shopID,
    required String ownerID,
    // required String visitorID,
  }) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "shopID": shopID,
      // 'visitor': visitorID
    };
    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/show/posts/owner/$shopID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      print(parsedResult);
      return parsedResult;
    }
    return null;
  }

  Future<String> deletePost(
      {required String postID,
      required String shopID,
      required String ownerID}) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
      "shopID": shopID,
      "postID": postID,
    };
    response = await http.delete(
      Uri.http(ENDPOINT, '/delete/post/$postID'),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json ',
      },
    );
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<String> updatePost({
    required String postID,
    required String ownerID,
    required String shopID,
    required String name,
    required String description,
    required String? photos,
    required String price,
    required String postImageType,
  }) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": ownerID, //ownerID
      "postID": postID,
      "shopID": shopID,
      "name": name,
      "description": description,
      "photos": photos,
      "price": price,
      "postImageType": postImageType,
    };
    response = await http.put(
      Uri.http(ENDPOINT, '/profile/post/$postID'),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<String> addPost({
    required String shopeID,
    required String ownerID,
    required String name,
    required String description,
    required String? photos,
    required String category,
    required String price,
    required String postImageType,
  }) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": ownerID, //ownerID
      "shopID": shopeID,
      "name": name,
      "description": description,
      "photos": photos,
      "category": category,
      "price": price,
      "postImageType": postImageType,
    };
    response = await http.post(
      Uri.http(ENDPOINT, '/AddPost/$shopeID'),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<Map<String, dynamic>?> getAllPosts() async {
    String userID = globalSharedPreference.getString("ID")!;

    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": userID,
    };
    // print(requestBody);
    try {
      response = await http.post(
          Uri.http(ENDPOINT, "/show/posts/followedStores/$userID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
      //  print(response.statusCode);
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

  Future<Map<String, dynamic>?> toggoleFavoritePost({
    required String postID,
    required String userID,
  }) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": userID,
      "postID": postID,
    };
    //  print(requestBody);
    try {
      response = await http.post(Uri.http(ENDPOINT, "/like/$userID/$postID"),
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          });
    } catch (e) {
      return null;
    }
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      parsedResult = jsonDecode(response.body);
      return parsedResult;
    }
    return null;
  }

  Future<Map<String, dynamic>?> showFavoritePosts(
      {required String ownerID}) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": ownerID,
    };

    try {
      response = await http.post(Uri.http(ENDPOINT, "show/my/Like/$ownerID"),
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
}
