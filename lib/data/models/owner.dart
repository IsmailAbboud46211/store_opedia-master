import 'dart:convert';

import 'package:shopesapp/data/models/shop.dart';

class Owner {
  String id;
  String name;
  String email;
  String password;
  String phoneNumber;
  dynamic currentShop;
  Owner({
    required this.name,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.id,
    required Shop currentShop,
  });

  Map<String, dynamic> toMap(Owner owner) {
    return <String, dynamic>{
      'id': owner.id,
      'email': owner.email,
      'phoneNumber': owner.phoneNumber,
      'password': owner.password,
      'name': owner.name,
    };
  }

  factory Owner.from(Owner oldOnwerObject) {
    return Owner(
        id: oldOnwerObject.id,
        name: oldOnwerObject.name,
        email: oldOnwerObject.email,
        phoneNumber: oldOnwerObject.phoneNumber,
        currentShop: oldOnwerObject.currentShop,
        password: oldOnwerObject.password);
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['ownerID'] as String,
      email: map['email'] as String,
      phoneNumber: map['ownerPhoneNumber'] as String,
      name: map["ownerName"] as String,
      password: map['password'] as String,
      currentShop: Shop(
          shopCategory: 'shopCategory',
          location: 'location',
          startWorkTime: 'startWorkTime',
          endWorkTime: 'endWorkTime',
          ownerID: 'ownerID',
          ownerEmail: 'ownerEmail',
          ownerPhoneNumber: 'ownerPhoneNumber',
          shopID: 'shopID',
          shopName: 'shopName',
          ownerName: 'ownerName',
          latitude: 0.0,
          longitude: 0.0),
    );
  }

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);
}
