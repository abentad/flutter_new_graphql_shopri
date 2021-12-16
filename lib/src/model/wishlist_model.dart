// To parse this JSON data, do
//
//     final wishList = wishListFromJson(jsonString);

import 'dart:convert';

WishList wishListFromJson(String str) => WishList.fromJson(json.decode(str));

String wishListToJson(WishList data) => json.encode(data.toJson());

class WishList {
  WishList({
    required this.id,
    required this.productId,
    required this.userId,
    required this.product,
  });

  String id;
  String productId;
  String userId;
  Product product;

  factory WishList.fromJson(Map<String, dynamic> json) => WishList(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
        "product": product.toJson(),
      };
}

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
