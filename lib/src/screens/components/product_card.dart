import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import '../../utils/product_image_loader.dart';
import '../../utils/price_format.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.hasShadows = false,
    required this.imageHeight,
    required this.imageWidth,
    required this.blurHash,
    required this.name,
    required this.image,
    required this.price,
    required this.ontap,
    required this.index,
    required this.size,
    this.radiusDouble = 15.0,
    required this.id,
  }) : super(key: key);
  final String name;
  final int id;
  final String price;
  final String image;
  final int index;
  final Size size;
  final int imageHeight;
  final int imageWidth;
  final String blurHash;
  final double radiusDouble;
  final bool hasShadows;
  final Function() ontap;
  double doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        boxShadow: [
          hasShadows ? BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, 3), blurRadius: 10.0) : const BoxShadow(color: Colors.transparent, offset: Offset(2, 5), blurRadius: 10.0),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusDouble),
        onTap: ontap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xfff2f2f2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
                child: CachedNetworkImage(
                  imageUrl: getProductImage(image),
                  placeholder: (context, url) => SizedBox(
                    //TODO: Fix the height and width of the blur hash to the right size of the image
                    // height: (double.parse(imageHeight.toString()) / size.height * 100) + 60.0,
                    // width: double.parse(imageWidth.toString()) / size.width * 100,
                    height: size.height * 0.15,
                    // width: size.width,
                    child: BlurHash(
                      hash: blurHash,
                    ),
                  ),
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radiusDouble), bottomRight: Radius.circular(radiusDouble)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.01),
                      Text(name.toString().capitalize.toString(), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        '${formatPrice(price)} birr',
                        style: const TextStyle(fontSize: 15.0, color: Colors.grey),
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Get.find<ApiController>().addToWishList(id);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Get.find<ApiController>().checkFavorite(id) ? Colors.pink : Colors.grey.shade400,
                      // color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
