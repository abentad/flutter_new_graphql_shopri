// To parse this JSON data, do
//
//     final productImage = productImageFromJson(jsonString);

import 'dart:convert';

ProductImage productImageFromJson(String str) => ProductImage.fromJson(json.decode(str));

String productImageToJson(ProductImage data) => json.encode(data.toJson());

class ProductImage {
  ProductImage({
    required this.imageId,
    required this.id,
    required this.url,
  });

  int imageId;
  int id;
  String url;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
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
