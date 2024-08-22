import 'dart:convert';

import 'package:shopesapp/main.dart';

class Post {
  String? shopeID;
  String postID;
  String title;
  String? description;
  String photos;
  String? category;
  String? ownerID;
  String? ownerName;
  String? ownerPhoneNumber;
  String price;
  int? rate;
  bool? isFavorit;
  String? shopProfileImage;
  String? shopCoverImage;
  String? shopCategory;
  String? shopName;
  String? location;
  double? latitude;
  double? longitude;

  Post(
      {required this.title,
      this.description = '',
      required this.category,
      required this.ownerID,
      required this.ownerName,
      required this.ownerPhoneNumber,
      required this.price,
      required this.photos,
      required this.shopeID,
      this.isFavorit = false,
      this.rate = 0,
      required this.postID,
      this.shopCategory,
      this.shopCoverImage,
      this.shopName,
      this.shopProfileImage,
      this.location,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopeID': shopeID,
      'title': title,
      'description': description,
      'category': category,
      'ownerID': ownerID,
      'postID': postID,
      'ownerName': ownerName,
      'ownerPhoneNumber': ownerPhoneNumber,
      'price': price,
      'photos': photos,
      'shopName': shopName,
      'shopCategory': shopCategory,
      'shopProfileImage': shopProfileImage,
      'shopCoverImage': shopCoverImage,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'isFavorit': isFavorit
    };
  }

  factory Post.from(Post post) {
    return Post(
        title: post.title,
        description: post.description,
        category: post.category,
        ownerID: post.ownerID,
        ownerName: post.ownerName,
        ownerPhoneNumber: post.ownerPhoneNumber,
        price: post.price,
        photos: post.photos,
        shopeID: post.shopeID,
        postID: post.postID,
        shopName: post.shopName,
        shopCategory: post.shopCategory,
        shopProfileImage: post.shopProfileImage,
        shopCoverImage: post.shopCoverImage,
        location: post.location,
        latitude: post.latitude,
        longitude: post.longitude,
        isFavorit: post.isFavorit);
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      title: map['title'],
      description: map['description'],
      category: map['category'] ??
          globalSharedPreference.getString("shopCategory") ??
          '',
      ownerID: map['ownerID'] ?? globalSharedPreference.getString('ID'),
      ownerName: map['ownerName'] ?? globalSharedPreference.getString("name"),
      ownerPhoneNumber: map['ownerPhoneNumber'] ??
          globalSharedPreference.getString("phoneNumber"),
      price: map['price'],
      photos: map['photos'],
      shopeID: map['shopeID'] ?? globalSharedPreference.getString('shopID'),
      postID: map['postID'],
      shopName: map['shopName'],
      shopCategory: map['shopCategory'],
      shopProfileImage: map['shopProfileImage'],
      shopCoverImage: map['shopCoverImage'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isFavorit: map["isLike"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}
