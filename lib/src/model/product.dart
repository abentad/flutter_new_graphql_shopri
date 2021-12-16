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
    required this.posterName,
    required this.posterProfileAvatar,
    required this.posterPhoneNumber,
  });

  int id;
  String isPending;
  int views;
  String name;
  String price;
  String description;
  String category;
  String image;
  DateTime datePosted;
  String posterId;
  String posterName;
  String posterProfileAvatar;
  String posterPhoneNumber;

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
        posterName: json["posterName"],
        posterProfileAvatar: json["posterProfileAvatar"],
        posterPhoneNumber: json["posterPhoneNumber"],
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
        "posterName": posterName,
        "posterProfileAvatar": posterProfileAvatar,
        "posterPhoneNumber": posterPhoneNumber,
      };
}
