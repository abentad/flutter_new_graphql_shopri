// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.isPending,
    required this.views,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.datePosted,
    required this.posterId,
    required this.poster,
    required this.images,
    required this.height,
    required this.width,
    required this.blurHash,
  });

  String id;
  String isPending;
  int views;
  String name;
  String price;
  String description;
  String category;
  String image;
  DateTime datePosted;
  String posterId;
  Poster poster;
  List<Image> images;
  int height;
  int width;
  String blurHash;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        isPending: json["isPending"],
        views: json["views"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        category: json["category"],
        image: json["image"],
        datePosted: DateTime.parse(json["datePosted"]),
        posterId: json["posterId"],
        poster: Poster.fromJson(json["poster"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        height: json["height"],
        width: json["width"],
        blurHash: json["blurHash"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isPending": isPending,
        "views": views,
        "name": name,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
        "datePosted": datePosted.toIso8601String(),
        "posterId": posterId,
        "poster": poster.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "height": height,
        "width": width,
        "blurHash": blurHash,
      };
}

class Image {
  Image({
    required this.imageId,
    required this.id,
    required this.url,
  });

  String imageId;
  String id;
  String url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageId: json["image_id"],
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "id": id,
        "url": url,
      };
}

class Poster {
  Poster({
    required this.id,
    required this.deviceToken,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.dateJoined,
  });

  String id;
  String deviceToken;
  String username;
  String email;
  String phoneNumber;
  String profileImage;
  DateTime dateJoined;

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
        id: json["id"],
        deviceToken: json["deviceToken"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        profileImage: json["profile_image"],
        dateJoined: DateTime.parse(json["dateJoined"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceToken": deviceToken,
        "username": username,
        "email": email,
        "phoneNumber": phoneNumber,
        "profile_image": profileImage,
        "dateJoined": dateJoined.toIso8601String(),
      };
}
