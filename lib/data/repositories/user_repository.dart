import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopesapp/constant/endpoint.dart';

//BOTH OF USER AND OWNER USER THIS FILE
class UserRepository {
  Future<Map<String, dynamic>?> updateUser(
      {required String id,
      required String name,
      required String password,
      required String phoneNumber}) async {
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": id,
      "userName": name,
      "password": password,
      "phoneNumber": phoneNumber
    };
    http.Response response;
    try {
      response = await http.put(
        Uri.http(ENDPOINT, '/profile/$id'),
        body: jsonEncode(requestBody),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
    } catch (e) {
      return null;
    }
    parsedResult = jsonDecode(response.body);
    return parsedResult;
  }

  Future<String> deleteUser({required String id}) async {
    http.Response response;
    Map<String, dynamic> requestBody = {"id": id};
    response = await http.delete(
      Uri.http(ENDPOINT, '/delete/$id'),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<String> contactUS({
    required String id,
    required String type,
    required String description,
    required String? photo,
    required String? imageType,
  }) async {
    http.Response response;
    Map<String, dynamic> requestBody = {
      "id": id,
      "type": type,
      "description": description,
      "photo": photo,
      "creation_date": DateTime.now().toString(),
      "reply": " ",
      "reply_date": " ",
      "imageType": imageType,
    };
    //   print(requestBody);
    response = await http.post(
      Uri.http(ENDPOINT, '/inbox/$id'),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<Map<String, dynamic>?> getCahtMessages({
    required String userID,
  }) async {
    http.Response response;
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": userID,
    };
    //   print(requestBody);
    try {
      response = await http.post(
        Uri.http(ENDPOINT, '/showReply/inbox/$userID'),
        body: jsonEncode(requestBody),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
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
}
