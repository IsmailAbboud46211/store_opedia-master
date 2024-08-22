/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopesapp/constant/endpoint.dart';
import 'package:shopesapp/data/models/shop.dart';
*/
// USER AND OWNER USE THE SAME CUBIT (USER CUBIT)
// WE CAN DELETE THIS FILE
/*
class OwnerRepository {
  Future<String> deleteOwner({required String id}) async {
    http.Response response;
    Map<String, dynamic> requestBody = {"id": id};
    response = await http.delete(
      Uri.parse(ENDPOINT + '/$id'),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json; ',
      },
    );
    if (response.statusCode == 200) {
      return "Success";
    }
    return "Failed";
  }

  Future<Map<String, dynamic>?> updateOwner(
      {required String id,
      required String userName,
      required String email,
      required String password,
      required Shop currentShop,
      required String phoneNumber}) async {
    Map<String, dynamic> parsedResult;
    Map<String, dynamic> requestBody = {
      "id": id,
      "userName": userName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "currentShop": currentShop
    };
    http.Response response;
    try {
      response = await http.put(
        Uri.parse(ENDPOINT + '/$id'),
        body: jsonEncode(requestBody),
        headers: <String, String>{'Content-Type': 'application/json;'},
      );
      parsedResult = jsonDecode(response.body);
      return (parsedResult);
    } catch (e) {
      print(e);
    }
    return null;
  }
}*/
